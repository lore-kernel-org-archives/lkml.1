Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZAIUxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZAIUxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZAIUw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:52:56 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:49204 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZAIUwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:52:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=F1xCUkDNUJ4ueUNaFjca3zwbwMyYxT+HyAyV8LrJDbDqf1nEw0EWlCnTOwRE6eid6e
         IE2eKwotxvCHkG/OayVrlWlrgZPxqHwaApl7Lovihk18/uQWah8FEBDcFUH1jYo8Bs+C
         Dus0Ql5FoZjux2j1BVyIeGoHhY9+fMlT8zdgE=
Message-ID: <86802c440901091252r2eab513dnf048851aea505d8d@mail.gmail.com>
Date: Fri, 9 Jan 2009 12:52:53 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [GIT PULL] bzip2/lzma kernel compression
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alain Knaff" <alain@knaff.lu>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <200901091845.n09IjBsT003630@terminus.zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901091845.n09IjBsT003630@terminus.zytor.com>
X-Google-Sender-Auth: 9f882e4e2df98acb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 10:45 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hi Linus,
>
> This tree contains the bzip2 and LZMA kernel compression work that
> Alain Knaff has done.  Sending this as a separate pull request in case
> you think that it is too late or immature for this cycle.
>
> The good part is that it is a highly "brittle" feature -- if it fails,
> it will fail noisily and obviously.
>
> I have not included the ARM parts that Alain developed; I will leave
> those to be fed through rmk.
>
> One of the main attractions of this patchset is that it uses the newer
> lib/zlib_inflate code even for the kernel decompressor.  Once all
> architectures that use the older lib/inflate.c have been converted
> over, we can remove that code entirely.

it seems still have some problem
mydisk13_x86_64.lzma is by lzma -9

[   47.404316] RAMDISK: lzma image found at block 0
[   51.676838] RAMDISK: incomplete write (-28 != 130)
[   51.894794] calling  5_generic_delete_inode_async+0x0/0xa9 @ 2316
[   51.900895] initcall 5_generic_delete_inode_async+0x0/0xa9 returned
0 after 3 usecs
[   51.901117] kjournald starting.  Commit interval 5 seconds
[   51.901130] EXT3 FS on ram0, internal journal
[   51.901138] EXT3-fs: mounted filesystem with ordered data mode.
[   51.901151] VFS: Mounted root (ext3 filesystem) on device 1:0.
[   51.901168] async_waiting @ 1
[   51.904191] calling  6_generic_delete_inode_async+0x0/0xa9 @ 2317
[   51.907123] initcall 6_generic_delete_inode_async+0x0/0xa9 returned
0 after 2861 usecs
[   51.947093] async_continuing @ 1 after 44846 usec
[   51.951839] Freeing unused kernel memory: 448k freed
[   51.957245] init_special_inode: bogus i_mode (4467)
