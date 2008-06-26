Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbYF0MUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbYF0MUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760275AbYF0MLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:11:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2928 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761478AbYF0MLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:11:17 -0400
Date: Thu, 26 Jun 2008 22:17:55 +0200
From: Pavel Machek <pavel@suse.cz>
To: Tomas M <tomas@slax.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: LZMA compression algorithm in Kernel - any chance to allow it?
Message-ID: <20080626201754.GE9878@ucw.cz>
References: <48634BA7.6030902@slax.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48634BA7.6030902@slax.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-06-26 09:56:23, Tomas M wrote:
> Hello.
> I can see the 2.6.25 kernel includes LZO compression algorithm in:
> 
> [*] Cryptographic API
>  < > LZO compression algorithm
> 
> As far as I could see, there was a strong pressure against putting compression algorithms in kernel. Does this LZO example mean that kernel people are now more open to include other algorithms as well? I'd like to include LZMA algo, which has far better compression ratio then anything else widely used today, and is already used in many small or embeded systems (as external patches to kernel or userspace utilities)
> 
> If I (or anybody else) submit LZMA code for inclusion in kernel, would you ACCEPT IT ?? (assuming the code looks nice to you)

You need some good reason why lzma should be in kernel... like 'cramfs
can use it'...?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
