Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbZEFLNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbZEFLNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbZEFLMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:12:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38205 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935AbZEFLMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:12:50 -0400
Date: Wed, 6 May 2009 13:12:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Message-ID: <20090506111243.GI25203@elte.hu>
References: <20090506104436.GA24047@lst.de> <20090506110354.GG25203@elte.hu> <20090506110746.GA25088@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506110746.GA25088@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Christoph Hellwig <hch@lst.de> wrote:

> On Wed, May 06, 2009 at 01:03:54PM +0200, Ingo Molnar wrote:
> > i think these markers are still in active use,
> 
> It's trivially proveable by grep that there is real no user.
> (modulo ad-hoc out of tree modules, which we've never cared about
> retaining stuff)

Well, i'll defer to Ted about whether those out of tree uses are 
relevant to ext4. It's not a problem to do this all in a polite way, 
without destroying functionality.

	Ingo
