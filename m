Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbYD2VFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbYD2VFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:05:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbYD2VEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:04:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57059 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYD2VEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:04:52 -0400
Date: Tue, 29 Apr 2008 23:04:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
Message-ID: <20080429210435.GA23008@elte.hu>
References: <1209268817.14173.43.camel@brick> <20080427042051.GL5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427042051.GL5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sat, Apr 26, 2008 at 09:00:17PM -0700, Harvey Harrison wrote:
> > As written, this can never be true.
> 
> ... and introduced through x86.git, of all things...  May I suggest 
> that in addition to all-important whitespace hunting something that 
> catches lowly real bugs would also be run over that tree?  sparse 
> *does* catch that...

firstly, it _was_ caught via Sparse, secondly, if you check the code 
flow, the bug - while indeed ugly looking - was harmless and had no 
side-effects. That's why it didnt trigger in testing.

	Ingo
