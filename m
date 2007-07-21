Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbXGUUB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbXGUUB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 16:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759886AbXGUUBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 16:01:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52771 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761792AbXGUUBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 16:01:07 -0400
Subject: Re: from where comes "__moddi3"?
From: Peter Zijlstra <peterz@infradead.org>
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070721195830.GK22998@lug-owl.de>
References: <Pine.LNX.4.64.0707211516480.6972@localhost.localdomain>
	 <1185046274.5652.15.camel@lappy>  <20070721195830.GK22998@lug-owl.de>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 22:00:53 +0200
Message-Id: <1185048053.5652.18.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 21:58 +0200, Jan-Benedict Glaw wrote:
> On Sat, 2007-07-21 21:31:13 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Sat, 2007-07-21 at 15:21 -0400, Robert P. J. Day wrote:
> > 
> > use do_div().
> > 
> > 16 works because gcc translates that into a right shift.
> 
> Right shift?  Doesn't it just mask out everything but the low 4 bit?

Yeah, its bitwise and for modulo and shifts for mult and div.

Silly mistake on my side.

