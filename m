Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbYA0Kso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbYA0Kso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 05:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYA0Ksf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 05:48:35 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43561 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYA0Kse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 05:48:34 -0500
Date: Sun, 27 Jan 2008 11:48:33 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jon Masters <jcm@redhat.com>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
In-Reply-To: <1201321306.32422.146.camel@perihelion>
Message-ID: <Pine.LNX.4.64.0801271145060.15243@fbirervta.pbzchgretzou.qr>
References: <1201029235.18144.62.camel@perihelion> 
 <Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr> 
 <1201275090.25284.281.camel@perihelion>  <200801261427.34902.rusty@rustcorp.com.au>
 <1201321306.32422.146.camel@perihelion>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 25 2008 23:21, Jon Masters wrote:
>On Sat, 2008-01-26 at 14:27 +1100, Rusty Russell wrote:
>
>> 2) Unconditionally reject modules with a wrong module section size.  Currently 
>> we have no such check, which means without KALLSYMS, anything goes.
>
>I favor the latter, since it's safest.

Is it possible to keep allowing the case where {section size is the
same and only the symversions are different}?
