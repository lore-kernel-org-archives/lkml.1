Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbZE0SAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbZE0SAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762262AbZE0SA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:00:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51664 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbZE0SAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:00:24 -0400
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 27 May 2009 11:00:17 -0700
In-Reply-To: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org> (Alan Stern's message of "Tue\, 26 May 2009 22\:17\:41 -0400 \(EDT\)")
Message-ID: <m1ljoi1l5a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: stern@rowland.harvard.edu, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, kay.sievers@vrfy.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Stern <stern@rowland.harvard.edu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 27 May 2009, Kay Sievers wrote:
>
>> On Wed, May 27, 2009 at 01:49, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> 
>> > OK ... perhaps we have to wait a little harder: try this; it waits until
>> > all the targets have disappeared from visibility via an event.
>> 
>> That seems to work fine here.
>
> It's good for a short-term fix.  For the longer term, I still think 
> it's a mistake to wait for the sdevs to be released before deleting the 
> target.  It gives user programs the ability to block the host-removal 
> thread indefinitely.

How can user programs block removal indefinitely today?

Eric
