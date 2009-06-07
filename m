Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZFGMQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZFGMQx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZFGMQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:16:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52071 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZFGMQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:16:44 -0400
Date: Sun, 7 Jun 2009 14:15:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       jdike@addtoit.com, hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [Patch 4/5] module: trim exception table in module_free()
Message-ID: <20090607121549.GA31173@elte.hu>
References: <20090604014813.6332.18486.sendpatchset@localhost.localdomain> <20090604014849.6332.35945.sendpatchset@localhost.localdomain> <200906041800.54696.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041800.54696.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thu, 4 Jun 2009 11:16:37 am Amerigo Wang wrote:
> > Just as the comment said, trim the exception table entries when
> > module_free() mod->module_init.
> >
> > Currently, this is only done for x86. Other platforms should 
> > also fix it like this (except sparc32).
> 
> I've taken this one to make it more generic.  I'll leave the x86 
> maintainers to apply the rest.

I think it makes most sense to handle them together. We have no 
interacting changes pending in the x86 tree, feel free to pick them 
up.

	Ingo
