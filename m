Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYBEE4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYBEE4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYBEE4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:56:05 -0500
Received: from garbage.rmnet.it ([82.145.99.230]:46401 "EHLO garbage.rmnet.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYBEE4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:56:02 -0500
X-Greylist: delayed 650 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 23:56:01 EST
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Tue, 05 Feb 2008 05:43:10 +0100
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux
 kernel
From: Matteo Tescione <matteo@rmnet.it>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
CC: Mike Christie <michaelc@cs.wisc.edu>, Vladislav Bolkhovitin <vst@vlnb.net>,
       <linux-scsi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       <scst-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <C3CDA7EE.5784%matteo@rmnet.it>
Thread-Topic: [Scst-devel] Integration of SCST in the mainstream Linux
 kernel
Thread-Index: AchnsZsn2fwOENOkEdyg7QAZ4zZdpQ==
In-Reply-To: <alpine.LFD.1.00.0802041620110.3237@woody.linux-foundation.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-RMnet-garbage-MailScanner: Found to be clean
X-RMnet-garbage-MailScanner-SpamCheck: non spam,
	SpamAssassin (punteggio=-1.799, necessario 4.5, autolearn=not spam,
	ALL_TRUSTED -1.80, BAYES_50 0.00)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
And sorry for intrusion, i am not a developer but i work everyday with iscsi
and i found it fantastic.
Altough Aoe, Fcoe and so on could be better, we have to look in real world
implementations what is needed *now*, and if we look at vmware world,
virtual iron, microsoft clustering etc, the answer is iSCSI.
And now, SCST is the best open-source iSCSI target. So, from an end-user
point of view, what are the really problems to not integrate scst in the
mainstream kernel?

Just my two cent,
--
So long and thank for all the fish
--
#Matteo Tescione
#RMnet srl


> 
> 
> On Mon, 4 Feb 2008, Matt Mackall wrote:
>> 
>> But ATAoE is boring because it's not IP. Which means no routing,
>> firewalls, tunnels, congestion control, etc.
> 
> The thing is, that's often an advantage. Not just for performance.
> 
>> NBD and iSCSI (for all its hideous growths) can take advantage of these
>> things.
> 
> .. and all this could equally well be done by a simple bridging protocol
> (completely independently of any AoE code).
> 
> The thing is, iSCSI does things at the wrong level. It *forces* people to
> use the complex protocols, when it's a known that a lot of people don't
> want it. 
> 
> Which is why these AoE and FCoE things keep popping up.
> 
> It's easy to bridge ethernet and add a new layer on top of AoE if you need
> it. In comparison, it's *impossible* to remove an unnecessary layer from
> iSCSI.
> 
> This is why "simple and low-level is good". It's always possible to build
> on top of low-level protocols, while it's generally never possible to
> simplify overly complex ones.
> 
> Linus
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 


