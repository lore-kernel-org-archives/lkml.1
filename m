Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbYCFWX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbYCFWX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbYCFWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:23:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759704AbYCFWXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:23:11 -0500
Date: Thu, 6 Mar 2008 23:22:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Pawel Plociennik <paplociennik@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306222254.GB8862@elte.hu>
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com> <20080306212028.GB1747@elf.ucw.cz> <20080306214218.GA886@elte.hu> <47D06717.9000104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D06717.9000104@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

>> i really find it so disheartening at times that people fight trivial 
>> usability additions tooth and nail in a _9 million lines of code_ 
>> kernel with a ... "bloat" argument.
>
> Because they come in one at a time, in a completely disorganized 
> fashion (which you yourself complain on further down.)

yeah. I've got a CONFIG_BOOTPARAM patch already, which turns a lot of 
boot parameters into .config options. (this is one of our conceptual 
holes: for many boot parameters there's no matching .config)

another thing is that i think all parameters should have all their forms 
active: so if there's "noacpi", then "acpi=0/1", "acpi=off/on" should 
work as well.

furthermore, usability shortcuts for common combinations would be useful 
too. Like "serialdebug" could be used as a shortcut for 
"earlyprintk=ttyS0,115200 console=ttyS0,115200 console=vga debug". 
Things like that would be really cool.

	Ingo
