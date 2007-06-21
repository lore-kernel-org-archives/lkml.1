Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbXFUTgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbXFUTgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbXFUTfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:35:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbXFUTft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:35:49 -0400
To: david@lang.hm
Cc: Andrew McKay <amckay@iders.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4679557C.5080907@iders.ca>
	<20070620175627.319a6c55@the-village.bc.nu>
	<46797C52.4020907@iders.ca>
	<orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
	<ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
	<orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
	<ory7idpykk.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706210031280.31603@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 16:34:19 -0300
In-Reply-To: <Pine.LNX.4.64.0706210031280.31603@asgard.lang.hm> (david@lang.hm's message of "Thu\, 21 Jun 2007 00\:33\:12 -0700 \(PDT\)")
Message-ID: <ork5txksp0.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, david@lang.hm wrote:

> On Thu, 21 Jun 2007, Alexandre Oliva wrote:
>> On Jun 21, 2007, david@lang.hm wrote:
>> 
>>> no, one of the rules for the network is that the software must be
>>> certified,
>> 
>> In this case you might have grounds to enforce this restriction of the
>> network on the network controller itself, I suppose.

> how would the network controller know if the software has been modified?

The loader could check that and set a flag in the controller.

> what sort of signal can the network controller send that couldn't be
> forged by the OS?

Whatever the network controller designer created to enable it to do
so.

> how would you do this where the device is a receiver on the netwoek
> (such as a satellite receiver)

If it's input-only, then you can't possibly harm the operation of the
network by only listening in, can you?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
