Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbXL3NDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbXL3NDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXL3NC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:02:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56169 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXL3NC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:02:57 -0500
Date: Sun, 30 Dec 2007 13:57:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Islam Amer <pharon@gmail.com>
Cc: "David P. Reed" <dpreed@reed.com>,
       Richard Harman <richard@richardharman.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071230125708.GA14424@elte.hu>
References: <47765D11.2040903@reed.com> <1198967334.5049.3.camel@iamer-laptop> <1198974925.7055.0.camel@iamer-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198974925.7055.0.camel@iamer-laptop>
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


* Islam Amer <pharon@gmail.com> wrote:

> Sorry, pressed send too soon. here is the line in dmesg:
> 
> Compaq Presario v6000: using alternate I/O delay port
> 
> Thanks, please tell me if you need anymore info.

thanks Islam for testing this. I've added your DMI strings to x86.git, 
so v2.6.25 should work out of box on your system.

	Ingo
