Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYCaMvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYCaMvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbYCaMvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:51:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069AbYCaMvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:51:17 -0400
Date: Mon, 31 Mar 2008 14:50:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: 20080331020341.GB24702@atjola.homenet
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bob Tracy <rct@frus.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix off-by-one errors in some pirq warnings
Message-ID: <20080331125057.GD14636@elte.hu>
References: <20080331022253.GA24987@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080331022253.GA24987@atjola.homenet>
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


* Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

> The conditions for the warnings simply ignored the fact that we later 
> actually use the original value minus 1, so the warning triggered even 
> for valid values.

thanks Björn, applied.

	Ingo
