Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbZEDRS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbZEDRS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZEDRSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:18:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49333 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZEDRSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:18:16 -0400
To: paulmck@linux.vnet.ibm.com
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       tridge@samba.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
References: <20090504124129.GL7141@linux.vnet.ibm.com>
	<20090504124433.GW8822@parisc-linux.org>
	<20090504130638.GN7141@linux.vnet.ibm.com>
	<20090504132119.GX8822@parisc-linux.org>
	<20090504143919.GA6740@linux.vnet.ibm.com>
	<20090504150834.GZ8822@parisc-linux.org>
	<1241451391.20170.12.camel@norville.austin.ibm.com>
	<m14ow0hnal.fsf@fess.ebiederm.org>
	<1241453259.20170.17.camel@norville.austin.ibm.com>
	<m1k54wal0j.fsf@fess.ebiederm.org>
	<20090504164250.GF6740@linux.vnet.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 04 May 2009 10:18:09 -0700
In-Reply-To: <20090504164250.GF6740@linux.vnet.ibm.com> (Paul E. McKenney's message of "Mon\, 4 May 2009 09\:42\:50 -0700")
Message-ID: <m1d4ao4wj2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mjt@tls.msk.ru, linux-fsdevel@vger.kernel.org, hirofumi@mail.parknet.co.jp, smfrench@gmail.com, hch@infradead.org, pavel@ucw.cz, viro@ZenIV.linux.org.uk, tridge@samba.org, matthew@wil.cx, shaggy@linux.vnet.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;paulmck@linux.vnet.ibm.com
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4877]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Mon, May 04, 2009 at 09:30:20AM -0700, Eric W. Biederman wrote:
>> Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:
>> 
>> > That's for the maintainers to decide.  If they agree it has worth, maybe
>> > it's a good idea to answer "How".
>> 
>> Al and Christoph said essentially the same thing and they generally
>> are considered the general area filesystem maintainers.
>> 
>> This kind of thing does not appear to have come up before and
>> so procedurally you guys are setting are attempting to set
>> a precedent.
>> 
>> All I know is that doing it the way you are doing seems like a bad
>> idea.  Not discussing things or even the reason you can't discuss them
>> seems foolish and leaves no one satisfied.
>> 
>> Maybe there are good reasons but so far this whole thing just stinks.
>> 
>> When all of the pieces are public how can having secret veiled reasons
>> make sense?
>> 
>> And if secret magic consultations with lawyers are going to be invoked
>> I expect we should have a Signed-off-by from those lawyers.
>
> ;-)
>
> Matthew's idea of checking with SFLC seems to me to have some merit.
> I am looking into this from my end.  Of course, you and Al and Christoph
> have just as much standing to ask SFLC as do I, and perhaps more.

Reasonable.  Of course it still misses one interesting point.

Typically when reviewing code if the code looks suspicious you ask the
poster why they did X.  If the author of the code has a good answer
you can tell that they have done their homework, and you can verify it.
If the author doesn't have a good answer typically that means they haven't
thought through all of the details and the code has problems.

In this case we ask why and get stone-walling.  Which typically would
mean either that IBM has a good reason for doing this that they are
keeping hidden.  Or that we have programmers reacting to news stories
who have not done all of their homework.

So far my feeling has been, that there are people handling this mess
on other fronts and that if it was a real issue they would be coming
out of the wood work, and giving guidance.

Now perhaps no one is because this is a cross disciplinary thing and no
one has sufficient legal, technical and business expertise.

Right now my hypothesis that best fits the facts is programmers reacting
on their own to news stories, without having done all of their homework.

Asking others to go to the SFLC or other places and do your homework
for you is an interesting reaction.  The SFLC does seem like an
appropriate group to get an opinion from.

Eric
