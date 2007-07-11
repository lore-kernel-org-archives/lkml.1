Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbXGKKyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbXGKKyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbXGKKyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:54:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58573 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbXGKKyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:54:15 -0400
Date: Wed, 11 Jul 2007 12:54:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Benjamin Budts <benjamin.budts@scarlet.be>
Cc: kvm-devel@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: gcc + kvm + 64 bit ? confused :-/
Message-ID: <20070711105413.GA18767@one.firstfloor.org>
References: <20070709071640.GB10864@one.firstfloor.org> <46920270.3080309@qumranet.com> <46921BE9.4040801@qumranet.com> <a781481a0707091224s3fb1a2acr6d3ccce091480f61@mail.gmail.com> <4693211D.4040406@qumranet.com> <a781481a0707100222k4f204ed8gfd4823bc21b7bf25@mail.gmail.com> <46936766.20900@qumranet.com> <a781481a0707101707w121da1b7hc82dc0e3638e4570@mail.gmail.com> <46948626.6050308@qumranet.com> <4694A63E.1050606@scarlet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4694A63E.1050606@scarlet.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 11:43:26AM +0200, Benjamin Budts wrote:
> I'm a bit confused using the -march=xxx options for gcc when using a 
> kernel virtual machine...
> Getting errors on smp when using the -march=nocoma for gcc... possibly 


What errors? 

> because smp is not fully supported yet I suppse.
> 
> I guess my question is, when installing kvm, is the virtual machine 64 
> bit capable or should I install 32 bit OS ?
> 
> I installed an amd64 debian image and it seems to be running 
> fine...except for the problem mentioned above.
> 
> And what type of architecture do i have to mention with gcc in a kvm ? 
> march ... arch...

The same as the host or generic cpu if you're not sure.

-Andi
