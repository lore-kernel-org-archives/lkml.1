Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZEDQal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZEDQal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZEDQaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:30:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40140 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZEDQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:30:29 -0400
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
References: <20090501210109.GA3079@infradead.org>
	<20090502013729.GI6996@linux.vnet.ibm.com>
	<20090503225616.GD8633@ZenIV.linux.org.uk>
	<20090504063431.GK7141@linux.vnet.ibm.com>
	<m11vr5jrba.fsf@fess.ebiederm.org>
	<20090504124129.GL7141@linux.vnet.ibm.com>
	<20090504124433.GW8822@parisc-linux.org>
	<20090504130638.GN7141@linux.vnet.ibm.com>
	<20090504132119.GX8822@parisc-linux.org>
	<20090504143919.GA6740@linux.vnet.ibm.com>
	<20090504150834.GZ8822@parisc-linux.org>
	<1241451391.20170.12.camel@norville.austin.ibm.com>
	<m14ow0hnal.fsf@fess.ebiederm.org>
	<1241453259.20170.17.camel@norville.austin.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 04 May 2009 09:30:20 -0700
In-Reply-To: <1241453259.20170.17.camel@norville.austin.ibm.com> (Dave Kleikamp's message of "Mon\, 04 May 2009 11\:07\:39 -0500")
Message-ID: <m1k54wal0j.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: shaggy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mjt@tls.msk.ru, linux-fsdevel@vger.kernel.org, hirofumi@mail.parknet.co.jp, smfrench@gmail.com, hch@infradead.org, pavel@ucw.cz, viro@ZenIV.linux.org.uk, tridge@samba.org, paulmck@linux.vnet.ibm.com, matthew@wil.cx
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Kleikamp <shaggy@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1484]
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

Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:

> That's for the maintainers to decide.  If they agree it has worth, maybe
> it's a good idea to answer "How".

Al and Christoph said essentially the same thing and they generally
are considered the general area filesystem maintainers.

This kind of thing does not appear to have come up before and
so procedurally you guys are setting are attempting to set
a precedent.

All I know is that doing it the way you are doing seems like a bad
idea.  Not discussing things or even the reason you can't discuss them
seems foolish and leaves no one satisfied.

Maybe there are good reasons but so far this whole thing just stinks.

When all of the pieces are public how can having secret veiled reasons
make sense?

And if secret magic consultations with lawyers are going to be invoked
I expect we should have a Signed-off-by from those lawyers.

Eric
