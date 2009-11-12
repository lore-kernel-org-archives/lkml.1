Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZKLXDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZKLXDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZKLXDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:03:50 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:48330 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZKLXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:03:50 -0500
Date: Thu, 12 Nov 2009 13:16:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
	fast string.
Message-ID: <20091112121604.GC1394@ucw.cz>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-11-09 15:24:03, Ma, Ling wrote:
> Hi All
> 
> Today we run our benchmark on Core2 and Sandy Bridge:
> 
> 1. Retrieve result on Core2
> Speedup on Core2
>    Len        Alignement             Speedup
>   1024,       0/ 0:                 0.95x 
>   2048,       0/ 0:                 1.03x 

Well, so you are running cache hot and it is only a win on huge
copies... how common are those?

> Application run through perf
> For (i= 1024; i < 1024 * 16; i = i + 64)
> 	do_memcpy(0, 0, i);

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
