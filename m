Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYAQSKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYAQSKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYAQSKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:10:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbYAQSKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:10:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1: broken suspend
Date: Thu, 17 Jan 2008 19:13:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171913.36854.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of January 2008, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 
> - selinux is busted on one of my two selinux-enabled test machines.
> 
> - suspend-to-ram and suspend-to-disk are totally hosed on one of my test
>   machines.  I guess I get to bisect this.

Please see if reverting pm-acquire-device-locks-on-suspend-rev-3.patch helps
and if it doesn't, please see if reverting git-acpi.patch helps.

Everyone having suspend/hibernation problems with this kernel, please check
if reverting reverting pm-acquire-device-locks-on-suspend-rev-3.patch (and the
fixes) helps first.

Thanks,
Rafael

