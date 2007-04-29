Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbXD2HYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbXD2HYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbXD2HYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:24:39 -0400
Received: from gw.goop.org ([64.81.55.164]:40805 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258AbXD2HYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:24:38 -0400
Message-ID: <4634483E.9030307@goop.org>
Date: Sun, 29 Apr 2007 00:24:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org> <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> All it does is set a flag that tells a bootloader.
> "Hey. I can run when loaded a non-default address, and this is what
>  you have to align me to."
>
> All relocation processing happens in the kernel itself.
>   

Is it possible to decompress and extract the kernel image from the
bzImage without executing it?  Ie, is there enough information to find
the compressed data part of the bzImage by inspection?

At some point we'll need to change the Xen domain builder to handle
bzImage files, and it would be best if we didn't need to run them.

    J
