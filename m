Return-Path: <linux-kernel-owner+w=401wt.eu-S1751469AbZL3VhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbZL3VhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZL3VhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:37:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39896 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZL3VhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:37:02 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Bryan Donlan <bdonlan@gmail.com>,
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
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
References: <m1iqbpwjtp.fsf@fess.ebiederm.org>
	<20091229223631.GB22578@us.ibm.com>
	<m1aax1uoa3.fsf_-_@fess.ebiederm.org>
	<3e8340490912291954v5a837a26p64bd776102d281d7@mail.gmail.com>
	<m1r5qdt721.fsf@fess.ebiederm.org>
	<3e8340490912292057g3e87eaabn115f85b78af2b08c@mail.gmail.com>
	<m1d41w62zc.fsf_-_@fess.ebiederm.org>
	<551280e50912300652r1007dee0j8de750bf33af9b3c@mail.gmail.com>
	<20091230183513.GC14493@us.ibm.com> <m1fx6suswz.fsf@fess.ebiederm.org>
	<20091230201712.GA23999@us.ibm.com>
	<m1hbr8tb8q.fsf_-_@fess.ebiederm.org>
	<20091230212931.233003b9@lxorguk.ukuu.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 30 Dec 2009 13:36:57 -0800
In-Reply-To: <20091230212931.233003b9@lxorguk.ukuu.org.uk> (Alan Cox's message of "Wed\, 30 Dec 2009 21\:29\:31 +0000")
Message-ID: <m1skasrvnq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Added bprm->nosuid to make remove the need to add
>> duplicate error prone checks.  This ensures that
>> the disabling of suid executables is exactly the
>> same as MNT_NOSUID.
>
> Another fine example of why we have security hooks so that we don't get a
> kernel full of other "random security idea of the day" hacks.

Well it comes from plan 9.  Except there they just simply did not
implement suid.  What causes you to think dropping the ability
to execute suid executables is a random security idea of the day?

Eric
