Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYATXu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYATXu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 18:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbYATXuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 18:50:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48904 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179AbYATXuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 18:50:20 -0500
Date: Mon, 21 Jan 2008 00:50:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: ACPI early ioremap problems II
Message-ID: <20080120235000.GA23512@elte.hu>
References: <20080119030843.GA2028@basil.nowhere.org> <20080119150328.GA32370@elte.hu> <20080119152649.GA1375@one.firstfloor.org> <20080119153055.GA12054@elte.hu> <20080119154651.GA1626@one.firstfloor.org> <20080119184543.GA3751@elte.hu> <20080119191621.GA3865@one.firstfloor.org> <20080120164817.GA26820@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120164817.GA26820@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> As a followup I see this problem on three different 64bit machines 
> now. Symptom is usually that only one core is active because ACPI 
> doesn't see the other processors in its tables.

to be able to have a chance to fix it we need you meet the minimum 
threshold for bugreports: please send the failing .config and a full 
boot message of the incident as well. (Please also check latest x86.git, 
maybe it's something that got fixed today.)

I have tested latest x86.git#mm on 3 different 64bit machines and Thomas 
tested it too, and none of us saw any crashes. So whatever you are 
seeing, it's unfortunately not very common to trigger.

	Ingo
