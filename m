Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZAMTb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZAMTb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZAMTbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:31:20 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:9564 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbZAMTbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:31:19 -0500
From: Frans Pop <elendil@planet.nl>
To: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [2.6.28] Kernel panic after closing lid on HP 2510p
Date: Tue, 13 Jan 2009 20:31:16 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200901121356.46236.elendil@planet.nl> <20090113123056.GA2464@deprecation.cyrius.com>
In-Reply-To: <20090113123056.GA2464@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901132031.16998.elendil@planet.nl>
X-OriginalArrivalTime: 13 Jan 2009 19:31:17.0327 (UTC) FILETIME=[812955F0:01C975B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009, Martin Michlmayr wrote:
> * Frans Pop <elendil@planet.nl> [2009-01-12 13:56]:
> > I got the following series of errors while closing the lid of my
> > notebook. The end result was a frozen system that needed a hard power
> > off.
>
> ...
>
> > System is HP 2510p notebook running 2.6.28 (x86_64, Debian
> > amd64/lenny) with a few additional patches on top.
>
> This came up on lkml and elsewhere before.  It's probably a BIOS bug.
> You can work around it with:
>
>   echo 7 > /proc/acpi/video/C09A/DOS

Thanks Martin, I'll give that a try.
