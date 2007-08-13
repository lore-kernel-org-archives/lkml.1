Return-Path: <linux-kernel-owner+w=401wt.eu-S940675AbXHMNAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940675AbXHMNAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968605AbXHMIDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:03:43 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:48823 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965155AbXHMIDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:03:34 -0400
Message-ID: <46C01052.4050708@dgreaves.com>
Date: Mon, 13 Aug 2007 09:03:30 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: david@lang.hm
Cc: Paul Clements <paul.clements@steeleye.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [RFD] Layering: Use-Case Composers (was: DRBD - what is it, anyways?
 [compare with e.g. NBD + MD raid])
References: <200708121335.17267.a1426z@gawab.com> <Pine.LNX.4.64.0708121325170.28963@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0708120933210.19502@asgard.lang.hm> <Pine.LNX.4.64.0708121901290.28963@fbirervta.pbzchgretzou.qr> <20070812174549.GA2915@teal.hq.k1024.org> <46BFB6BB.80406@steeleye.com> <Pine.LNX.4.64.0708122016100.22470@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0708122016100.22470@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> per the message below MD (or DM) would need to be modified to work 
> reasonably well with one of the disk components being over an unreliable 
> link (like a network link)
> 
> are the MD/DM maintainers interested in extending their code in this 
> direction? or would they prefer to keep it simpler by being able to 
> continue to assume that the raid components are connected over a highly 
> reliable connection?
> 
> if they are interested in adding (and maintaining) this functionality 
> then there is a real possibility that NBD+MD/DM could eliminate the need 
> for DRDB. however if they are not interested in adding all the code to 
> deal with the network type issues, then the argument that DRDB should 
> not be merged becouse you can do the same thing with MD/DM + NBD is 
> invalid and can be dropped/ignored
> 
> David Lang

As a user I'd like to see md/nbd be extended to cope with unreliable links.
I think md could be better in handling link exceptions. My unreliable memory 
recalls sporadic issues with hot-plug leaving md hanging and certain lower level 
errors (or even very high latency) causing unsatisfactory behaviour in what is 
supposed to be a fault 'tolerant' subsystem.


Would this just be relevant to network devices or would it improve support for 
jostled usb and sata hot-plugging I wonder?

David

