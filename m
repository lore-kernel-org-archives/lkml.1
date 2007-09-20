Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbXITLSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbXITLSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 07:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbXITLSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 07:18:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:55998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXITLSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 07:18:21 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: patch/option to wipe memory at boot?
To: Chris Snook <csnook@redhat.com>, David Madore <david.madore@ens.fr>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Reply-To: 7eggert@gmx.de
Date: Thu, 20 Sep 2007 13:17:40 +0200
References: <94rE7-89j-3@gated-at.bofh.it> <94tmJ-2EJ-77@gated-at.bofh.it> <94vHE-6xa-11@gated-at.bofh.it> <95cD1-7gI-31@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1IYK2O-0000iq-D8@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18KVmt/uq0JMffDn2nfy/vauqjDF5swn4VQVwj
 qOjTblMvGjjZ66+z9ndlcJsUqSqgbjMjp38OrNTk/k/8e7pq9D
 UC/2K2SvVv6xIPyf/gsIA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> wrote:
> David Madore wrote:
>> On Mon, Sep 17, 2007 at 11:11:52AM -0700, Jeremy Fitzhardinge wrote:

>>> Boot memtest86 for a little while before booting the kernel?  And if you
>>> haven't already run it for a while, then that would be your first step
>>> anyway.
>> 
>> Indeed, that does the trick, thanks for the suggestion.  So I can be
>> quite confident, now, that my RAM is sane and it's just that the BIOS
>> doesn't initialize it properly.
>> 
>> But I'd still like some way of filling the RAM when Linux starts (or
>> perhaps in the bootloader), because letting memtest86 run after every
>> cold reboot isn't a very satisfactory solution.
> 
> Bootloaders like to do things like run in 16-bit or 32-bit mode on boxes where
> higher bitness is necessary to access all the memory.  It may be possible to
> do this in the bootloader, but the BIOS is clearly the correct place to fix
> this problem.

Just an idea: Does this BIOS have an option to (not) skip the full memory
test on bootup?
-- 
Have you ever noticed that the Klingons are all speaking unix?
"Grep ls awk chmod."   "Mknod ksh tar imap."
"Wall fsck yacc!"     (that last is obviously a curse of some sort)
        -- Gandalf  Parker
