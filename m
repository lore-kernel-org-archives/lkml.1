Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZIRMYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZIRMYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZIRMYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:24:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33852 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZIRMYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:24:35 -0400
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org>
	<20090918055423.GA7104@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Sep 2009 05:24:32 -0700
In-Reply-To: <20090918055423.GA7104@kroah.com> (Greg KH's message of "Thu\, 17 Sep 2009 22\:54\:23 -0700")
Message-ID: <m1k4zw4f0f.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs maintenance disaster
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> I'm really sorry, but I know of no existing bugs in this code.
> Seriously, I thought we addressed everything that was pointed out.

Then please sober up and open your eyes.  Bugs are not hard to find.
And I pointed out about 5 of them at the beginning of my message.

The simplest and most trivial of them is that the error handling
path is device_add was not updated to remove the devtmpfs node
if it was not created.

I find it maximally offensive that when I try and give constructive
criticism that I am either written off or told that my patches will
be summarily dropped.

The code I think is fixable.  You I have much less hope for.

Eric
