Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZK1WJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZK1WJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 17:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZK1WJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 17:09:08 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:35982 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752606AbZK1WJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 17:09:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=K7QJR1jZZrOYNcaEWqgEtGtbPNzZNufpVIh18syXCTkoZYHwHbzSjR1CHjhkJhlXpBOaYnc7SDbhGV0MamlERwEGERK/D+h37lS24CjwZTVu0sa7n/zPbAcwPTB/hzssPtYLfw2YPL5AN/p2sG1oTFZAImQUArG3tCnTYQT20/4=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: 8atgxckVM1kiKbLYdgF5A95g.YKZK79DzRcA5g1mfH6suIOOTg5Zx7W23dEKrgukjrh3smNenQqTVpz3LSohEbvxRCeDRlzSU3hp9gWqOOQokcqN34VuPHhQxUxncwzB6LPfJHOYKK6GQA_e462PkzdxrtNv0LliFE1NTy__cow_CRIPldV_CZTKhZyBCbS5YBUfIpxYb2eswP3z36hlAtl_h0Z9CF4YYbKGvPwrDFQs1cRLefYqfwzwjWc1DTs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED registered with setup_irq
Date: Sat, 28 Nov 2009 14:09:13 -0800
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-arm-kernel@lists.infradead.org
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain> <20091128200344.GA1272@pengutronix.de>
In-Reply-To: <20091128200344.GA1272@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200911281409.13807.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 November 2009, Uwe Kleine-König wrote:
>  I just thought that a
> warning that is triggered with request_irq and request_threaded_irq
> shouldn't be skipped when using setup_irq.

Seems fair to me.
