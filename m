Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYESO2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYESO2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbYESO1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:27:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:56805 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbYESO1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TtcqenPwCOQJKlnGmgw7Guju5CAtZDoDUmJ5s7oOWvpSUJuxBU6c/CmAL8xUpYX1iJBGmysG1kEQUTfb7mQajzoAQOZWkptplcgSCoUhcqe0lGyzVCxih0T58xsU3K7HFaFFmMviGlMTorkR65yE7ARuwKwMitbUY9Bhj/8BHy8=
Date: Mon, 19 May 2008 18:27:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Adrian Bunk <bunk@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080519142739.GA7773@cvg>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <20080518180811.GI8140@cs181133002.pp.htv.fi> <483071DE.6010404@firstfloor.org> <483076FA.9040605@goop.org> <48307FC0.8010704@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48307FC0.8010704@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Sun, May 18, 2008 at 09:13:04PM +0200]
| Jeremy Fitzhardinge wrote:
| > Andi Kleen wrote:
| >> The whole idea was pretty bad. Ifdefs are not ugly because the syntax
| >> looks ugly, but because it's a semantically ugly construct with bad
| >> maintainability impact.
| >>
| >> Trying to put syntactical sugar around that is a doomed exercise. It
| >> will be still ugly, no matter what you do.
| > 
| > Not true.  Using C rather than CPP to control the compilation of config
| > options has the big win that all code paths are still visible to the
| > compiler. 
| 
| A small win. Still lots of other problems, including testing.
| 
|  In some cases that's not what you want, but it often is, and
| > it would avoid some degree if inadvertent breakage of options.  It can
| > also be syntactically a lot more pleasant.
| 
| Well it's still an unnecessary different code path and making
| it look nicer is just an excuse from properly cleaning it up.
| 
| -Andi
| 

ok, thanks to all reviewers for the look being taken. I will try to
eliminate as much #ifdefs as possible, make them straight and understandable
and will send the next patch as only get it done. Thanks to all!

		- Cyrill -
