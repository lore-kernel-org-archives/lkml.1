Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYG2KsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYG2KsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYG2KsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:48:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:34041 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbYG2KsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:48:08 -0400
Subject: Re: interrupt overhead on ARM architecture
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alessio Sangalli <alesan@manoweb.com>
Cc: Iwo Mergler <iwo@call-direct.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <488EC1DA.7000708@manoweb.com>
References: <488E7F08.7060309@manoweb.com>
	 <488EA477.7070101@call-direct.com.au>  <488EC1DA.7000708@manoweb.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 20:47:49 +1000
Message-Id: <1217328469.11188.247.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 00:08 -0700, Alessio Sangalli wrote:
> Iwo Mergler wrote:
> 
> > In other words, you can't even measure the latency on a particular
> > system and then assume it will stay anywhere near constant. Comparing
> > different systems with the same processor core is hopeless.
> 
> Everything makes perfect sense. For this reason, I am willing to do some
> tests on my own platform. How would you suggest to proceed? I would need
> an extremely accurate way to measure time to begin with and then:
> 
> - read that time reference
> - generate an interrupt by placing some data in a device or so
> - reading again that time reference as first thing in the ISR
> - save the result
> 
> - do the above in various scenarios, with different drivers enabled, CPU
> load, etc etc

Do you have some device you can toy with such as an FPGA ? If not, you
can use also a pair of GPIOs hooked up to an oscillo.

Have one GPIO be an interrupt, and the interrupt handler for it toggle
the second GPIO.

Then, stick a push button to the first GPIO and wire it to your
oscilloscope's first input, and the second to the second input, set the
trigger on the first input, and here you go...

Ben.


