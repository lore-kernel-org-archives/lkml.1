Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXHDRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXHDRLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760709AbXHDRLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:11:09 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:48067
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760644AbXHDRLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:11:08 -0400
Date: Sat, 4 Aug 2007 10:09:19 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Javier Pello <javier.pello@urjc.es>
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
 notified
In-Reply-To: <46B43DBA.5040703@urjc.es>
Message-ID: <Pine.LNX.4.64.0708041007430.6905@asgard.lang.hm>
References: <46B37CF7.2020803@urjc.es>  <Pine.LNX.4.64.0708032219230.6905@asgard.lang.hm>
 <46B43DBA.5040703@urjc.es>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007, Javier Pello wrote:

>> I've been told that it's possible to have the kernel pull the firmware
>> off of an initrd (or was it initramfs, I keep confusing the two) without
>> having any userspace, just put the right file in the right place
>> (unfortunantly I've never gotten around to testing this) will this patch
>> break this feature?
>
> Correct me if I'm wrong, but I understand that the way this works is having
> the initramfs become an "early userspace", a filesystem that is mounted,
> well, earlier during boot, so that it is available before drivers begin
> to initialise (earlier: as a rootfs_initcall, as opposed to at the end of
> the boot process), but that in all respects behaves as a fully-fledged root
> filesystem. In particular, firmware should be requested from userspace in
> the standard way, and the patch should not break anything. I would test
> this to be sure, but I have absolutely no experience preparing an initramfs.

what I've been told is that with the drive built-in instead of modular you 
can create a filesystem that has only the firmware on it, nothing else, 
and have the kernel find and load it (no userspace software involved)

David Lang
