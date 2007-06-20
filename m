Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbXFTQkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbXFTQkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXFTQkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:40:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753315AbXFTQkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:40:05 -0400
Date: Wed, 20 Jun 2007 09:39:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexander Gabert <pappy@gentoo.org>
cc: Arjan van de Ven <arjan@infradead.org>, libc-alpha@sourceware.org,
       linux-kernel@vger.kernel.org, hardened@gentoo.org
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel
 2.6.21.5
In-Reply-To: <467948F5.3010709@gentoo.org>
Message-ID: <alpine.LFD.0.98.0706200937280.3593@woody.linux-foundation.org>
References: <4675C678.3080807@gentoo.org>  <1182128803.22999.9.camel@laptopd505.fenrus.org>
  <4675DFA8.6060703@gentoo.org> <1182130680.22999.13.camel@laptopd505.fenrus.org>
 <4676601A.7070209@gentoo.org> <467948F5.3010709@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Alexander Gabert wrote:
> 
> this patch adds the function drivers/char/random.c:get_random_long()

It's totally whitespace-damaged, and I wonder why the "int" vs "long" is 
so important. Also, what are the performance implications for execve?

		Linus
