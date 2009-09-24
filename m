Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZIXP6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZIXP6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZIXP6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:58:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40000 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751282AbZIXP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:58:31 -0400
Date: Thu, 24 Sep 2009 16:59:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Jing Huang <huangj@brocade.com>, James.Bottomley@HansenPartnership.com,
       kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
Subject: Re: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Message-ID: <20090924165944.6507432a@lxorguk.ukuu.org.uk>
In-Reply-To: <1253807042.20648.188.camel@desktop>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
	<1253807042.20648.188.camel@desktop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       return (*(union bfi_addr_u *) &addr);
> > +}
> 
> Have you run checkpatch on this code? It produces many errors due to
> your "return" usage for one.. The usual style of return is not to use
> parentheses since it's really not a function ..

checkpatch is just a helper tool - and stuff like that using
brackets to make it clearer is just a trivial matter of style.

> Checkpatch produces many other errors in your code .. If you haven't
> already evaluated those errors

It would be rather more useful if instead of parroting checkpatch results
(which people can generate themselves) you concentrated on analysis the
actual code and structure for any flaws and design details.

Trivia like coding style (unless particularly bad) are something for the
maintainer just to say "fix those odd bits up and I'll merge it" at the
*end*.

