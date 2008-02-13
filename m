Return-Path: <linux-kernel-owner+w=401wt.eu-S934186AbYBMXol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbYBMXol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934104AbYBMXo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:44:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764428AbYBMXoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:44:25 -0500
Date: Wed, 13 Feb 2008 15:43:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: harvey.harrison@gmail.com, torvalds@linux-foundation.org,
       davem@davemloft.net, tglx@linutronix.de, hpa@zytor.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported
 symbols going away
Message-Id: <20080213154331.f11efc63.akpm@linux-foundation.org>
In-Reply-To: <20080213232248.GF12383@cs181133002.pp.htv.fi>
References: <1202941327.18204.11.camel@brick>
	<20080213223455.GB12383@cs181133002.pp.htv.fi>
	<20080213224308.GD12383@cs181133002.pp.htv.fi>
	<20080213145405.35fb5733.akpm@linux-foundation.org>
	<20080213232248.GF12383@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 01:22:48 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> I don't get your point why bigger API changes should still be allowed 
> without any advance warning while removing an export should require 
> deprecation periods.

Because the cost to us of giving people a few months warning is miniscule,
and doing so a) is courteous to our users and b) possibly avoids driving
away testers.

otoh the cost to us of avoiding large API changes is much much higher, so
the tradeoff has a different outcome.

> If you want to offer a stable API for external modules then please do 
> it completely and with all consequences.

Sorry, but you have this belief that if we do X in one case then we should
rigorously do X in all cases.  That everything we do sets precedents which
must be forever and in all cases followed.  That it is all about rules and
sticking to them.  That if you can catch person A taking action B then you
can trap that person into doing B in all cases for ever more.

Well it doesn't work like that.  Each case is different and each case has
pros and cons and each one needs to be weighed according to those pros and
cons.
