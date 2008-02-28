Return-Path: <linux-kernel-owner+w=401wt.eu-S1762442AbYB1UcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442AbYB1UcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYB1UcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:32:06 -0500
Received: from mxi.ltu.se ([130.240.42.23]:53049 "EHLO mxi.ltu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbYB1UcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:32:05 -0500
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2008 15:32:04 EST
Message-ID: <47C71510.6060306@student.ltu.se>
Date: Thu, 28 Feb 2008 21:09:52 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: SL Baur <steve@xemacs.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Jan Engelhardt <jengelh@computergmbh.de>, bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: multiple updates
References: <1204062430.47c488def40a4@portal.student.luth.se>	 <20080226135444.f83a0536.randy.dunlap@oracle.com>	 <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>	 <Pine.LNX.4.64.0802270033310.5714@axis700.grange>	 <m31w6zcm4l.fsf@maximus.localdomain>	 <ed10ee420802261657w3830e1a1rf0cc9601cdacb142@mail.gmail.com>	 <20080226213432.1388717b.randy.dunlap@oracle.com>	 <47C5DDE0.3040403@student.ltu.se> <ed10ee420802271611l3a09e76ej531158f167512a03@mail.gmail.com>
In-Reply-To: <ed10ee420802271611l3a09e76ej531158f167512a03@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SL Baur wrote:
> On 2/27/08, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>
>   
>>  Actually, I see this as an quite simple question: is tab _the
>>  indention-marker_? If not, then why the refusal of spaces indents (or mix)?
>>     
>
> Because mixing spaces and tabs is often ugly.
I agree
>                                                8 spaces and a
> single tab often do not have the same width when you're viewing
> the text in a variable width font.
>
> I've read all my mail in a variable width font for over a decade, at
> first to watch for regressions in the XEmacs display engine, but I
> continued because I liked it.  I presume I'm not the only one doing
> so.
>
>   
Did not think anyone would read code with variable-sized font. :) In 
such case the 80-rule is of little use when it comes to readability.

But do you not think there is people with small screens (and perhaps an 
increasing number with the use of PDAs and smartphones), who would like 
to change the tab-size to fit a small window (recall someone talking 
about a 62 character wide screen), where a change from 8 to 2 gains 18 
characters in just 3 levels.
In those cases, an only-used-as-indent-character is most preferable.

Of course, there is little point in patching existing tab-alignments, 
but even less creating them, which checkpatch.pl like to do sometime, 
with its "tabs not spaces".

cheers
Richard Knutsson

