Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYERSgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYERSgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYERSfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:35:55 -0400
Received: from gw.goop.org ([64.81.55.164]:54087 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbYERSfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:35:54 -0400
Message-ID: <483076FA.9040605@goop.org>
Date: Sun, 18 May 2008 19:35:38 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <20080518180811.GI8140@cs181133002.pp.htv.fi> <483071DE.6010404@firstfloor.org>
In-Reply-To: <483071DE.6010404@firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The whole idea was pretty bad. Ifdefs are not ugly because the syntax
> looks ugly, but because it's a semantically ugly construct with bad
> maintainability impact.
>
> Trying to put syntactical sugar around that is a doomed exercise. It
> will be still ugly, no matter what you do.

Not true.  Using C rather than CPP to control the compilation of config 
options has the big win that all code paths are still visible to the 
compiler.  In some cases that's not what you want, but it often is, and 
it would avoid some degree if inadvertent breakage of options.  It can 
also be syntactically a lot more pleasant.

    J
