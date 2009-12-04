Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbZLDRaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbZLDRaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbZLDRav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:30:51 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36643 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206AbZLDRau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:30:50 -0500
Message-Id: <1259947857.14965.1348483153@webmail.messagingengine.com>
X-Sasl-Enc: vghcyFVCki5Hc+7gJ3ka12vQo0IH1e+0Kz9FMgnH62f/ 1259947857
From: myuboot@fastmail.fm
To: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>
Cc: linux-kernel@vger.kernel.org, "linux-mips" <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20091204160333.GA8842@alpha.franken.de>
References: <20091028103551.0b4052d8@pixies.home.jungo.com>
 <1259891550.19943.1348372917@webmail.messagingengine.com>
 <20091204160333.GA8842@alpha.franken.de>
Subject: Re: PIR OFFSET for AR7
Date: Fri, 04 Dec 2009 11:30:57 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Sorry, you are right. I mistook PM_OFFSET for PIR_OFFSET.

Thanks, Andrew
On Fri, 04 Dec 2009 17:03 +0100, "Thomas Bogendoerfer"
<tsbogend@alpha.franken.de> wrote:
> On Thu, Dec 03, 2009 at 07:52:30PM -0600, myuboot@fastmail.fm wrote:
> > Hi, What is the use of PIR register for AR7 board in file
> > arch/mips/ar7/irq.c?
> 
> it gives back the channel and line of the pending interrupt with the
> highest priority.
> 
> > If I understand it right, PIR is used to define the
> > polarity of the interrupts. It seems to me that it needs to initialized?
> 
> no, it's a read only register. Why do you think it has something to do
> with interrupt polarity ?
> 
> Thomas.
> 
> -- 
> Crap can work. Given enough thrust pigs will fly, but it's not necessary
> a
> good idea.                                                [ RFC1925, 2.3
> ]
