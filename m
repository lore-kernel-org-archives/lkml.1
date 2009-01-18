Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZARXny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZARXny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZARXnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:43:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbZARXnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:43:45 -0500
Date: Mon, 19 Jan 2009 00:43:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] x86-64: Convert irqstacks to per-cpu
Message-ID: <20090118234340.GA29450@elte.hu>
References: <1232296759-2253-1-git-send-email-tj@kernel.org> <1232296759-2253-4-git-send-email-tj@kernel.org> <73c1f2160901181016t61cd1954s3ced677ab5b3b28a@mail.gmail.com> <4973BD73.6010001@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4973BD73.6010001@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., i think we could (and should) now remove pda.h altogether. The stack 
canary percpu structure should be defined in stackprotector.h [that file 
is available in tip/master] - and all the PDA references and accessors can 
be removed, right?

	Ingo
