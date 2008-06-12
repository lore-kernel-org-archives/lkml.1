Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbYFLNp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbYFLNp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762019AbYFLNot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:44:49 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:63189 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762576AbYFLNos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:44:48 -0400
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0806121533270.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.523866467@mvista.com>
	 <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>
	 <1213277402.16459.25.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806121533270.3193@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 06:44:46 -0700
Message-Id: <1213278286.16459.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 15:33 +0200, Thomas Gleixner wrote:
> On Thu, 12 Jun 2008, Daniel Walker wrote:
> > On Thu, 2008-06-12 at 10:56 +0200, Thomas Gleixner wrote:
> > > Please stop wasting everyone's time with that.
> > 
> > It achieves correct ordering of the futex waiters inside the kernel,
> > that is in fact _something_ ..
> 
> Yeah, just something _useless_

Just because you don't use it, doesn't make it useless .. At least
there's enough people asking for this that it warrants me writing it..

Daniel

