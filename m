Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYCCQIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYCCQIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYCCQIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:08:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54306 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYCCQId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:08:33 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] chroot= as a new kernel parameter
To: Pavel Machek <pavel@ucw.cz>, Guillaume Chazarain <guichaz@gmail.com>,
       Pawel Plociennik <paplociennik@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 03 Mar 2008 17:08:26 +0100
References: <a2zNf-7rl-7@gated-at.bofh.it> <a2YVo-4N6-27@gated-at.bofh.it> <a3k9B-4Cf-43@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JWDDH-00040q-54@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX186NEhsD7wjx1rXPVAyaVYCnfQ8gi9IbgqmDwm
 R7Jh4CIOV4OwBD7pIk8VKY+CmwFBvA3PerSycsPWni/TFIjmaA
 z980exmAVL4KQ+5PUWrog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:
>> On Sat, Mar 1, 2008 at 8:09 PM, Pawel Plociennik <paplociennik@gmail.com>

>> >  In the short this patch has added a new chroot= kernel parameter which can
>> >  be used to changing a chroot of an init process before it will has been
>> >  runed.
>> 
>> Wouldn't booting with 'init=/usr/sbin/chroot /path /sbin/init' achieve
>> the same effect?
>> Haven't tested it, just wondering.
> 
> This breaks down when there's no distribution installed in /, or when
> distro in / is badly broken.

Yes.

Real life example: I set up a system in qemu and moved it to ~/temp/foo
in order to test it before overwriting the old system. I had to boot into
/bin/sh, mount the home disc and chroot into that directory.

OTOH, I'm not sure if the kernel would have found my home if it were on LVM.


