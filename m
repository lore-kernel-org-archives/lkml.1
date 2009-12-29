Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZL2U45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZL2U45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbZL2U44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:56:56 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58009 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZL2U4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:56:54 -0500
To: Bryan Donlan <bdonlan@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
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
	<20091229163939.GA6984@us.ibm.com>
	<3e8340490912290901y60d7daf2w5778c25f44972955@mail.gmail.com>
	<m1fx6ty6ds.fsf@fess.ebiederm.org>
	<3e8340490912291108t7e000e75p8264fa585f831464@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 29 Dec 2009 12:56:44 -0800
In-Reply-To: <3e8340490912291108t7e000e75p8264fa585f831464@mail.gmail.com> (Bryan Donlan's message of "Tue\, 29 Dec 2009 14\:08\:30 -0500")
Message-ID: <m1ws05wlbn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bryan Donlan <bdonlan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: RFC: disablenetwork facility. (v4)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan <bdonlan@gmail.com> writes:

> It's probably reasonable to require that real == effective == saved ==
> fs UID (and same for GID); anything else brings up sticky issues of
> "which UID is a higher capability?"
> If a process does this call, it's effectively saying that the only way
> it's going to be accessing resources beyond its current UID and
> capabilities is by talking to another process over a (unix domain)
> socket.

Makes sense.  Especially for the initial implementation,
and it keeps the code size small.

Eric

