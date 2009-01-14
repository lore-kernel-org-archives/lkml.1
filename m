Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZANGvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZANGvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZANGvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:51:37 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:55704 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbZANGvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:51:37 -0500
Message-ID: <496D8B55.2000901@knaff.lu>
Date: Wed, 14 Jan 2009 07:51:01 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Al Viro <viro@ftp.linux.org.uk>, Alain Knaff <alain@knaff.lu>
Subject: Re: The policy on initramfs decompression failure
References: <496D17F9.8080605@zytor.com> <20090114011844.GD14730@mit.edu>
In-Reply-To: <20090114011844.GD14730@mit.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
>    failed-initramfs-decode=panic      Panic on failed initramfs
>    failed-initramfs-decode=partial    If the initramfs fails part-way in, 
>    				      decode what you can and let the boot
> 				      system see what files could be fully
> 				      decypted
>    failed-initramfs-decode=allow      If the initramfs decryption fails
>    				      part-of-the-way in, continue the
> 				      boot, but do not provide the partial
> 				      initramfs --- i.e., this is the 
> 				      all-or-nothing option

Interesting approach... but wouldn't it make more sense to have that be
global? Or else, eventually every single panic will have such a
tri-state switch, with associated option parsing and overhead, leading
to bloat.

> If this is too complicated, I'd be happy with the "panic on failed
> initramfs".  After all, the user can always simply delete the initrd
> specifier from their grub boot configuration, and simply retry the
> boot....

Exactly!

Regards,

Alain

