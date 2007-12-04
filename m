Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXLDMRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXLDMRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXLDMQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:16:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbXLDMQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:16:55 -0500
Date: Tue, 4 Dec 2007 13:16:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Michael Cree <mcree@orcon.net.nz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru,
       linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Message-ID: <20071204121618.GA26132@elte.hu>
References: <6A73BEE8-9D45-4B75-8756-3008A4B1FDF4@orcon.net.nz> <20071203011732.2CEABDBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203011732.2CEABDBA2@gherkin.frus.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bob Tracy <rct@gherkin.frus.com> wrote:

> Finally got back in town.  Starting the git-bisect process.  I've got 
> a relatively slow network connection, and the PWS 433au isn't exactly 
> what I would call "fast" by modern standards, so bear with me while I 
> get things set up and crank through this.  The clone of the 2.6 tree 
> will take several more hours to finish downloading.  I anticipate the 
> best pace I'll be able to manage after that is two iterations in a 24- 
> hour period.

once you are done with the download of the initial cloned git repository 
(which is 200MB+), all the bisection steps will be local and you'll be 
only limited by kernel rebuild speed and by bootup and testing speed, 
not by network bandwidth.

( once you have the cloned repository i'd suggest for you to keep it - 
  that way you can track susequent kernels via "git-pull" and it uses a 
  very network-efficient delta protocol. )

	Ingo
