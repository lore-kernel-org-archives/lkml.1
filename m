Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZLVPpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZLVPpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZLVPpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:45:52 -0500
Received: from khc.piap.pl ([195.187.100.11]:37654 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZLVPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:45:52 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Rob Landley <rob@landley.net>
Cc: Brian Gerst <brgerst@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why is ARCH m68k hardwired into drivers/net/wan/Makefile?
References: <200912202342.16806.rob@landley.net>
	<200912210204.08583.rob@landley.net>
	<73c1f2160912210648j2a8790b6ue611503ef931a77b@mail.gmail.com>
	<200912211654.43710.rob@landley.net>
Date: Tue, 22 Dec 2009 16:45:38 +0100
In-Reply-To: <200912211654.43710.rob@landley.net> (Rob Landley's message of
	"Mon, 21 Dec 2009 16:54:43 -0600")
Message-ID: <m3eimngggt.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> Explicitly saying somewhere "this card has an onbaord m68k processor even if 
> the host doesn't" might be nice.  I eventually figured it out, but neither the 
> makefile nor the firmware source actually said the card had an onboard 
> processor, and my first glance at the kconfig help text just went "it's code for 
> a QUICC processor, that's one of those freescale SoCs isnt it?  I vaguely 
> recall booting Linux on one of those back in 2006..."

QUICC = QUad Integrated Communications Controller (Morotola 68360) chip
and is based on m68020 IIRC. There is no "normal" m68k CPU on this board.

PowerQUICC is a different thing.
-- 
Krzysztof Halasa
