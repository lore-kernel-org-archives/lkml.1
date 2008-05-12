Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYELRW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYELRW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYELRWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:22:48 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33512 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbYELRWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:22:47 -0400
Date: Mon, 12 May 2008 19:23:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Paulo Marques <pmarques@grupopie.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
Message-ID: <20080512172323.GA9236@uranus.ravnborg.org>
References: <20080509174148.GA22246@basil.nowhere.org> <482491D6.9030205@grupopie.com> <4824A7B6.70306@firstfloor.org> <4824AD3C.3070506@grupopie.com> <20080509233742.GA22265@martell.zuzino.mipt.ru> <48281540.9020207@grupopie.com> <20080512155052.GB6913@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512155052.GB6913@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 07:50:52PM +0400, Cyrill Gorcunov wrote:
> [Paulo Marques - Mon, May 12, 2008 at 11:00:32AM +0100]
> > Alexey Dobriyan wrote:
> >> On Fri, May 09, 2008 at 08:59:56PM +0100, Paulo Marques wrote:
> >>> Andi Kleen wrote:
> >>>> [...]
> >>>> Yes and? Surely that's not correct?
> >>> That's not for me to judge, but I believe it has always been like that.
> >> *cough*
> >> Here is how typical /proc/kallsyms looks like:
> >> ffffffff80200000 A _text
> >> ffffffff80200000 T startup_64
> >> ffffffff802000b7 t ident_complete
> >> ffffffff80200100 T secondary_startup_64
> >
> > This isn't helpful... the question is whether it is kallsyms misbehaving 
> > and placing new symbols in the kernel image or if it is some other change 
> > in the kernel that is generating new symbols that end up in the symbol 
> > table.
> >
> > My guess it is that it is the later, and in that case, from a kallsyms 
> > standpoint "it has always been like that".
> >
> > -- 
> > Paulo Marques - www.grupopie.com
> >
> >
> 
> If it help - I've taken Andi's config, compiled the kernel and
> didn't find any screwed symbols (nor is System.map nor in /proc/kallsyms).

I expect it to be a toolchain issue. Andi is often running with gcc versions
that are very new (fresh from svn maybe). I dunno about binutils.
To reproduce I would expect that a very recent gcc/binutils is needed.
Andi?

	Sam
