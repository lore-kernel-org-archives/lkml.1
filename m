Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYLaEJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYLaEJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 23:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYLaEIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 23:08:51 -0500
Received: from ozlabs.org ([203.10.76.45]:54305 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbYLaEIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 23:08:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel modules (take 2)
Date: Wed, 31 Dec 2008 14:38:34 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: "linux-parisc" <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au> <495AA891.2030104@gmx.de>
In-Reply-To: <495AA891.2030104@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812311438.35394.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008 09:32:41 Helge Deller wrote:
> BTW, although the comment states that arches can change section sizes 
> in the module_frob_arch_sections() function:
> /* Allow arches to frob section contents and sizes.  */
> it will break horrible if you do so.
> What I found was, that if you change sh_size, at least the module
> references / dependency chain will break when running lsmod.

Well, you can change the size of NOBITS sections: other things are likely
to be less successful.  You could probably make them smaller, though.

Cheers,
Rusty.
