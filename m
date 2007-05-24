Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbXEXVCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbXEXVCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXEXVCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:02:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXEXVCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:02:00 -0400
Date: Thu, 24 May 2007 23:01:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070524210153.GB19672@elte.hu>
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524125453.GA7554@elte.hu> <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> 2.6.22-rc2, only EVENT_TRACE - boots, can't rerpoduce
> 2.6.21-vanila - can reproduce
> 2.6.21-rt7, trace options off - can reproduce
> 2.6.21-rt7, trace options on - can't reproduce
> 
> Possibly something timing related, that's altered by the trace code. I 
> tried the trace kernel without starting the trace app, but still no 
> bug.
> 
> Any other ideas?

perhaps try 2.6.21-rt7 with EVENT_TRACE on (the other trace options off) 
- does that hide the bug too?

	Ingo
