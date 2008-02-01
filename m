Return-Path: <linux-kernel-owner+w=401wt.eu-S965095AbYBAAJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095AbYBAAJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765536AbYBAAJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:09:37 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61559 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934555AbYBAAJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:09:36 -0500
Date: Thu, 31 Jan 2008 18:09:31 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM REMAINS: [sata_nv ADMA breaks ATAPI] Crash on accessing
 DVD-RAM
In-reply-to: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no>
To: Alexander <aledin@mail.ru>
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Message-id: <47A2633B.8080807@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander wrote:
> Hello!
> 
> The problem described at https://bugzilla.redhat.com/show_bug.cgi?id=351451 and
> at http://ubuntuforums.org/showthread.php?t=655772 and supposedly fixed by the
> patch http://kerneltrap.org/mailarchive/linux-kernel/2007/11/25/445094 is still
> there. I have compiled 2.6.24-rc7 kernel and booted my PC with it just to find
> out that my SATA DVD-RW is
> 
> sr0: scsi3-mmc drive: 0x/0x caddy
> 
> as it was before with 2.6.23.12 and earlier 2.6 kernels compiled for x86_64.
> Trying to use sr0 after this results in dead hang or reboot.
> When I put sata_nv.adma=0 or mem=4096M then it's all ok:

Can you (or others experiencing this problem) test the latest patch 
attached to the RH Bugzilla entry here:

https://bugzilla.redhat.com/show_bug.cgi?id=351451

and see if it resolves the problem? I have one report of success so far.
