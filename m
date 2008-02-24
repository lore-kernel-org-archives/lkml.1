Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbYBXJH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbYBXJH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 04:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYBXJHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 04:07:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:36720 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbYBXJHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 04:07:40 -0500
Date: Sun, 24 Feb 2008 10:07:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Samuel Tardieu <sam@rfc1149.net>
Cc: Andi Kleen <andi@firstfloor.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
Message-ID: <20080224090750.GB8169@uranus.ravnborg.org>
References: <20080207230304.GA4352@ghostprotocols.net> <p73ir0mxvby.fsf@bingen.suse.de> <20080224075821.GA7781@uranus.ravnborg.org> <2008-02-24-09-25-19+trackit+sam@rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2008-02-24-09-25-19+trackit+sam@rfc1149.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 09:25:19AM +0100, Samuel Tardieu wrote:
> Andy> -feliminate-unused-debug-types -feliminate-unused-debug-symbols
> Andy> -feliminate-dwarf2-dups
> 
> Sam> google did not turn up anything useful.  Do you have a poiter to
> Sam> where these are described?
> 
> >From GCC (svn) man page:
> 
>    -feliminate-unused-debug-symbols
>        Produce debugging information in stabs format (if that is sup‐
>        ported), for only symbols that are actually used.
> 
>    -feliminate-unused-debug-types
>        Normally, when producing DWARF2 output, GCC will emit debugging
>        information for all types declared in a compilation unit, regard‐
>        less of whether or not they are actually used in that compilation
>        unit.  Sometimes this is useful, such as if, in the debugger, you
>        want to cast a value to a type that is not actually used in your
>        program (but is declared).  More often, however, this results in a
>        significant amount of wasted space.  With this option, GCC will
>        avoid producing debug symbol output for types that are nowhere used
>        in the source file being compiled.
> 
>    -feliminate-dwarf2-dups
>        Compress DWARF2 debugging information by eliminating duplicated
>        information about each symbol.  This option only makes sense when
>        generating DWARF2 debugging information with -gdwarf-2.
> 

Hi Sam.

I did not include the '-f' part in my google search. When I did so I got more hits.

Thanks,
	Sam - who is not talking to himself ;-)
