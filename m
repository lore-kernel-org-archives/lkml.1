Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYHYK1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYHYK1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYHYK10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:27:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57729 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbYHYK1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:27:25 -0400
Date: Mon, 25 Aug 2008 12:27:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] Fix emergency_restart (sysrq-b) with kvm loaded on
	Intel hosts
Message-ID: <20080825102714.GA15810@elte.hu>
References: <1219655506-27418-1-git-send-email-avi@qumranet.com> <20080825091508.GC9114@elte.hu> <48B27AFE.3080704@qumranet.com> <20080825093020.GA5617@elte.hu> <48B28367.2040500@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B28367.2040500@qumranet.com>
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


* Avi Kivity <avi@qumranet.com> wrote:

>> reboot was always a bit fragile - i think we should only do that if 
>> we find a box where the FADT reset works better than the first-wave 
>> approaches we try.
>
> It worked on my host.  Since it will fall back to keyboard reset and 
> triple fault, it seems fairly safe.

... except if it hangs in ACPI/SMM code for whatever reason.

	Ingo
