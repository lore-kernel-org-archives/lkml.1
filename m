Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZEDGt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZEDGt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 02:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZEDGtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 02:49:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49818 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZEDGto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 02:49:44 -0400
To: paulmck@linux.vnet.ibm.com
Cc: tridge@samba.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com>
	<20090501210109.GA3079@infradead.org>
	<20090502013729.GI6996@linux.vnet.ibm.com>
	<20090503225616.GD8633@ZenIV.linux.org.uk>
	<18942.9606.411013.714178@samba.org>
	<m1ljpdl8yr.fsf@fess.ebiederm.org>
	<20090504063431.GK7141@linux.vnet.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 03 May 2009 23:49:29 -0700
In-Reply-To: <20090504063431.GK7141@linux.vnet.ibm.com> (Paul E. McKenney's message of "Sun\, 3 May 2009 23\:34\:31 -0700")
Message-ID: <m11vr5jrba.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mjt@tls.msk.ru, linux-fsdevel@vger.kernel.org, hirofumi@mail.parknet.co.jp, shaggy@linux.vnet.ibm.com, smfrench@gmail.com, matthew@wil.cx, hch@infradead.org, pavel@ucw.cz, viro@ZenIV.linux.org.uk, tridge@samba.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;paulmck@linux.vnet.ibm.com
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3632]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Sun, May 03, 2009 at 10:42:52PM -0700, Eric W. Biederman wrote:
>> The only reason I can see for not ultimately talking about things publicly
>> is if this is one company making shady deals with another company in which
>> case I do not see why the maintenance burden for those decision should
>> fall on the linux community as a whole.
>
> Another reason is that past experience would indicate that anything we
> say in public and and will be used against us.

Which is a fine reason to be careful what you say, and to say
reasonable things.  It is not a reason to submit a patch without
justification.

If the reason for submitting a patch is not sufficiently good to be
held to then it appears insufficient to merge the patch.

Why should the commit to a position at your urging that you aren't
willing to commit to?

Eric
