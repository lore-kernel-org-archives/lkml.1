Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZKDLSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZKDLSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZKDLSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:18:40 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:37684 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbZKDLSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:18:39 -0500
Date: Wed, 4 Nov 2009 12:19:57 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Arnaud Patard <apatard@mandriva.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: Re: [PATCH -queue v0 1/6] [loongson] add basic loongson-2f support
Message-ID: <20091104111957.GA13549@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com> <a1bd2470bc465e505281c761adca8c2287d102b3.1257325319.git.wuzhangjin@gmail.com> <m3iqdqtwgk.fsf@anduin.mandriva.com> <1257332652.8716.5.camel@falcon.domain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257332652.8716.5.camel@falcon.domain.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 07:04:12PM +0800, Wu Zhangjin wrote:

> > Small question : Why don't you restrict to 64bit kernels only ? From
> > what I remember from some discussions with ST, trying to use a 32-bit
> > kernel on 2f is a nice way to get troubles. It would be better imho to
> > forbid such a configuration. As a side effect, this will remove all
> > 'defined(CONFIG_64BIT)' parts of your #ifdef tests. 
> > 
> 
> It's hard to make such a decision ;) Perhaps some guys want to play with
> the 32bit version.

We have other systems where 32-bit kernel support is just remarkably ugly.
We've dropped 32-bit support for the SGI IP32 aka O2 - nobody seems to even
have really noticed that.  The Sibyte systems would be good candidates to do
the same as accesses to outside the 32-bit address space are needed very
frequently.

  Ralf
