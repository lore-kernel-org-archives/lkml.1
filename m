Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZJSJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZJSJ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZJSJ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:26:45 -0400
Received: from relay.atmel.no ([80.232.32.139]:55776 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbZJSJ0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:26:45 -0400
Date: Mon, 19 Oct 2009 18:26:30 +0900
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] consider stack access while checking for alternate
 signal stack
Message-ID: <20091019182630.7c4fa4c1@hskinnemoen-d830>
In-Reply-To: <20091019075824.GA25783@Chamillionaire.breakpoint.cc>
References: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
	<20091019130931.6d8f0340@hskinnemoen-d830>
	<20091019075824.GA25783@Chamillionaire.breakpoint.cc>
Organization: Atmel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy@breakpoint.cc> wrote:
> >Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:  
> >> Haavard: The AVR32 assumption is pure on gcc's STACK_PUSH_CODE which is
> >> POST_DEC. Could you please ack/nak it?  
> >
> >Hmm, no, that is not correct. AVR32 is definitely pre-decrement.
> >
> >Note that 8-bit AVR and AVR32 are two completely different
> >architectures.  
> Ah okay. So the AVR32 bits are not in upstream GCC yet?

No, unfortunately not. We're working on it, and have been for some
time, but the progress is very slow.

Haavard
