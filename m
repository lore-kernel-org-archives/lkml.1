Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZAQAbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZAQAbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 19:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZAQAb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 19:31:26 -0500
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:32967 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbZAQAbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 19:31:25 -0500
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [regression] hp-wmi: hangs system on boot
Date: Sat, 17 Jan 2009 01:31:21 +0100
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org
References: <200901170013.55786.elendil@planet.nl>
In-Reply-To: <200901170013.55786.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901170131.22541.elendil@planet.nl>
X-OriginalArrivalTime: 17 Jan 2009 00:31:23.0019 (UTC) FILETIME=[ECA125B0:01C9783A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 January 2009, Frans Pop wrote:
> When I first booted .29-rc2 my HP 2510p notebook hung while loading
> hp-wmi, which I have listed in /etc/modules. Hard poweroff was needed.

Reverting the following commit fixes the problems:

commit fe8e4e039dc3680681bf51af097af391f87038f8
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Fri Jan 9 16:40:54 2009 -0800

    hp-wmi: handle rfkill_register() failure
