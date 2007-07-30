Return-Path: <linux-kernel-owner+w=401wt.eu-S967987AbXG3TEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967987AbXG3TEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967347AbXG3TEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:04:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:41654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966506AbXG3TEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:04:43 -0400
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: =?iso-8859-1?q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix msr register allocation
References: <1185809155.4347.20.camel@t60>
	<20070730153734.GA6921@atjola.homenet> <1185813358.4347.24.camel@t60>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 Jul 2007 21:59:20 +0200
In-Reply-To: <1185813358.4347.24.camel@t60>
Message-ID: <p737iohr7c7.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa <gcosta@redhat.com> writes:

> > Note that the EAX output constraint is re-used in the input section for
> > (u32)val, i.e. the lower half of the value to be written. And "wrmsr"
> > needs that in EAX, so you cannot change the output constraint without
> > touching the input constraint.
> Right again. Will send a new patch that also changes the input constraint.

Please also "fix" the subject then. You can only fix something that's broken,
but this isn't.

-Andi
