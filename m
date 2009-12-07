Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZLGHF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZLGHF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZLGHF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:05:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbZLGHF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:05:56 -0500
Date: Mon, 7 Dec 2009 08:05:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       acme@ghostprotocols.net
Subject: Re: [PATCH 0/2] perf trace/scripting: A couple bugfixes
Message-ID: <20091207070556.GB10868@elte.hu>
References: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> One fixes a compile error when libperl isn't installed, the other
> fixes an annoying message about scripting being unsupported even when
> the perf trace cmd isn't trying to use scripting.
> 
> Tom Zanussi (2):
>   perf trace/scripting: Fix compile err when libperl not installed
>   perf trace/scripting: Don't display 'scripting unsupported' msg
>     unnecessarily
> 
>  tools/perf/util/trace-event-perl.c |   67 +++++++++++++++++++++++++++++------
>  tools/perf/util/trace-event-perl.h |    4 ++
>  2 files changed, 59 insertions(+), 12 deletions(-)

Applied, thanks a lot Tom!

( Note, i already applied patch #1 out of your previous email - this 
  version has the same content, right? )

	Ingo
