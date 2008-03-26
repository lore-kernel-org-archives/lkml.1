Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYCZJXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYCZJXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYCZJWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:22:53 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:12742 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750953AbYCZJWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:22:52 -0400
Date: Wed, 26 Mar 2008 18:22:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
       Ian Molton <spyro@f2s.com>, Alain L Knaff <Alain.Knaff@lll.lu>,
       David C Niemi <niemi@tux.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] SuperH floppy: kill 'register' keyword from floppy.h header
Message-ID: <20080326092227.GB7867@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
	Ian Molton <spyro@f2s.com>, Alain L Knaff <Alain.Knaff@lll.lu>,
	David C Niemi <niemi@tux.org>,
	Trivial Patch Monkey <trivial@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LNX.1.00.0803260213550.1901@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0803260213550.1901@dragon.funnycrock.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 02:16:32AM +0100, Jesper Juhl wrote:
> 
> When compilers became generally better at optimizing code than humans, the
> register keyword became mostly useless. For the floppy driver it certainly
> is since it's so slow compared to the rest of the system that optimizing
> access to a single variable or two isn't going to make any real
> difference
> So let's just leave it to the compiler - it'll do a better job anyway.
> 
> This patch does away with a few register keywords in the SuperH floppy
> driver.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

applied, thanks.
