Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZL3EdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZL3EdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 23:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZL3EdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 23:33:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56951 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZL3EdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 23:33:15 -0500
To: Bryan Donlan <bdonlan@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benny Amorsen <benny+usenet@amorsen.dk>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org>
	<20091229151146.GA32153@us.ibm.com>
	<3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
	<m3oclhzgm4.fsf@ursa.amorsen.dk> <m17hs5y0mg.fsf@fess.ebiederm.org>
	<20091229211139.0732a0c1@lxorguk.ukuu.org.uk>
	<m1iqbpwjtp.fsf@fess.ebiederm.org> <20091229223631.GB22578@us.ibm.com>
	<m1aax1uoa3.fsf_-_@fess.ebiederm.org>
	<3e8340490912291954v5a837a26p64bd776102d281d7@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 29 Dec 2009 20:33:10 -0800
In-Reply-To: <3e8340490912291954v5a837a26p64bd776102d281d7@mail.gmail.com> (Bryan Donlan's message of "Tue\, 29 Dec 2009 22\:54\:59 -0500")
Message-ID: <m1r5qdt721.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bryan Donlan <bdonlan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC][PATCH] Unprivileged: Disable acquisition of privileges
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan <bdonlan@gmail.com> writes:

> Is this sufficient for other security models such as selinux or
> TOMOYO? Can processes in these models gain privileges through means
> not restricted here?

The LSM is primarily about returning -EPERM more often.
Except for the prctl and the capability hooks I am not aware
of anywhere a LSM can increase a processes capabilities.

> Also, perhaps there should be a corresponding GET prctl?

Probably for the final version.

Eric

