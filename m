Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXFMUEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXFMUEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXFMUD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:03:57 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49732
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXFMUDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:03:55 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: davids@webmaster.com
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 16:03:48 -0400
User-Agent: KMail/1.9.6
Cc: "Simon Arlott" <simon@fire.lp0.eu>, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKEELKEHAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEELKEHAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131603.49152.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 June 2007 16:42:35 David Schwartz wrote:
> > http://www.eweek.com/article2/0,1759,1915720,00.asp
> > has the answer. Quoting Linus:
> >
> > "If you want to license a program under any later version of the
> > GPL, you have
> > to state so explicitly. Linux never did."
> >
> > Hence, unless there's a "GPL 2 or later", all the "unspecified GPL" files
> > are GPL2 only.
>
> The GPL states the default position:
>
> "If the Program does not specify a version number of this License, you may
> choose any version ever published by the Free Software Foundation."
>
> Leaving the question of whether Linus's comment at the top of the license
> changes the default:
>
> "Also note that the only valid version of the GPL as far as the kernel is
> concerned is _this_ particular version of the license (ie v2, not v2.2 or
> v3.x or whatever), unless explicitly otherwise stated."
>
> So we have dueling defaults. The GPL says the default is any version.
> Linus' statement at the top of the GPL says the default is v2 only. It's
> not clear, at least to me, that there is any clear reason why one should
> win out over the other.

Except that Linux included a copy of the license it was distributed under in 
the tarball, which was GPLv2.  There's a case to be made that this DOES count 
as "selection of the license version".  It's hard to get more explicit than 
including the complete license text.

On top of that, Linus clarified his position back in 2000:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0009.1/0096.html

This means that not only are his on contributions so licensed, but there's a 
strong case to be made that everything he merged since then is explicitly 
GPLv2 only when sourced from the Linux kernel.  As maintainer there's a good 
argument that he has a compliation copyright on the kernels he releases.  He 
was certainly accepting patches under GPLv2 only, and merging them into a 
GPLv2 only work.  Sourcing ANY code from that work and declaring it non-GPLv2 
is really fishy; much better to find a clean upstream source, such as the 
original authors.

Of course the FSF would very, very much like this not to have been the case, 
and they've been trying to wish it away ever since...

Rob
