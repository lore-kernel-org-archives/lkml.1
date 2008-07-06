Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYGFCv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYGFCv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 22:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYGFCvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 22:51:49 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33660 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYGFCvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 22:51:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sean Young <sean@mess.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>
References: <20080616121138.GA51097@atlantis.8hz.com>
	<200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org>
	<20080616161944.GA53539@atlantis.8hz.com>
	<20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org>
	<20080630220939.GA58260@atlantis.8hz.com>
Date: Sat, 05 Jul 2008 19:41:55 -0700
In-Reply-To: <20080630220939.GA58260@atlantis.8hz.com> (Sean Young's message
	of "Mon, 30 Jun 2008 22:09:39 +0000")
Message-ID: <m17ibz4tu4.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sean Young <sean@mess.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Regression: boot failure on AMD Elan TS-5500
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Young <sean@mess.org> writes:

> On Mon, Jun 30, 2008 at 02:52:10PM -0700, Jeremy Fitzhardinge wrote:
>> It's a bit odd that the boot loader neglected to set up ds properly, but 
>> changing the testb line to
>> 
>> 	testb $(1<<6), %cs:BP_loadflags(%esi)
>> 
>> should work.  (Or perhaps a %ss: override would be better?)
>
> Yup, it does (%cs: prefix).

Guys I have a fuzzy memory of reads and definitely writes through %cs not working,
on some processor models.  i386?

If that hadn't been the case I would have used that form more to remove the
dependencies before we reached lgdt in haed.S when I was in there years ago.

Eric
