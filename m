Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbXGFKMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbXGFKMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbXGFKLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:11:54 -0400
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:33092 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755300AbXGFKLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:11:53 -0400
X-YMail-OSG: qFav5.IVM1mG2nP.cYcVjB5OMhCOIzQUmGGh0Xr_zwetrqc4mDGbhT60qKoRLGq3uhYV2cUTLX7reKigPDgTY8q7cQ--
X-RocketYMMF: knobi.rm
Date: Fri, 6 Jul 2007 03:11:53 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <468D832B.4060002@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <197707.68164.qm@web32604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Robert Hancock <hancockr@shaw.ca> wrote:

> 
> Try playing with reducing /proc/sys/vm/dirty_ratio and see how that 
> helps. This workload will fill up memory with dirty data very
> quickly, 
> and it seems like system responsiveness often goes down the toilet
> when 
> this happens and the system is going crazy trying to write it all
> out.
> 

 Definitely the "going crazy" part is the worst problem I see with 2.6
based kernels (late 2.4 was really better in this corner case).

 I am just now playing with dirty_ratio. Anybody knows what the lower
limit is? "0" seems acceptabel, but does it actually imply "write out
immediatelly"?

 Another problem, the VM parameters are not really well dociúmented in
their behaviour and interdependence.

Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
