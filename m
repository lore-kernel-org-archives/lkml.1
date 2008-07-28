Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbYG1PgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbYG1PgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYG1Pf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:35:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54597 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYG1Pf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:35:56 -0400
Date: Mon, 28 Jul 2008 17:35:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Daniel K." <dk@uw.no>
Cc: Robert Richter <robert.richter@amd.com>,
       Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/24] oprofile: Add support for AMD Family 11h
Message-ID: <20080728153538.GB28495@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-4-git-send-email-robert.richter@amd.com> <488B5F93.3060600@uw.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488B5F93.3060600@uw.no>
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


* Daniel K. <dk@uw.no> wrote:

> Robert Richter wrote:
>> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
>> index 7f3329b..cf28a02 100644
>> --- a/arch/x86/oprofile/nmi_int.c
>> +++ b/arch/x86/oprofile/nmi_int.c
>> @@ -422,6 +422,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>>  			model = &op_athlon_spec;
>>  			cpu_type = "x86-64/family10";
>>  			break;
>> +		case 0x11:
>> +			model = &op_athlon_spec;
>> +			cpu_type = "x86-64/family11h";
>
> Should the 'h' be dropped, as for family10 above, to keep them similar.

'family10' is a typo we've got to live with - but there's no need to 
repeat it for family11h.

	Ingo
