Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZASXp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZASXp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZASXps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:45:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52094 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbZASXpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:45:47 -0500
Date: Tue, 20 Jan 2009 00:45:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-usb@vger.kernel.org,
       linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.29-rc2] ALi USB OHCI enables interrupts during power down
	in suspend.
Message-ID: <20090119234509.GB452@elte.hu>
References: <200901181642.00886.arvidjaar@mail.ru> <200901192013.46962.rjw@sisk.pl> <200901192333.40757.arvidjaar@mail.ru> <200901192148.02096.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901192148.02096.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > Yes.
> > 
> > Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> OK, thanks for the confirmation.
> 
> Time to write a changelog ...

Please also add capable debug checks. Andrey did great testing that pinned 
it down fast but still it took more than a dozen mails and a lot of 
patches to get here and that kind of expertise cannot be expected from 
normal bug-reporters.

	Ingo
