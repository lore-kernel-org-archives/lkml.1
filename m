Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZIRM5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZIRM5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZIRM5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:57:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40433 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZIRM5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:57:45 -0400
To: Scott James Remnant <scott@canonical.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	<20090917141303.428fe73c@lxorguk.ukuu.org.uk>
	<1253205332.4718.9.camel@quest>
	<20090917194725.355b761c@infradead.org>
	<1253213956.4718.18.camel@quest>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Sep 2009 05:57:35 -0700
In-Reply-To: <1253213956.4718.18.camel@quest> (Scott James Remnant's message of "Thu\, 17 Sep 2009 19\:59\:16 +0100")
Message-ID: <m1tyz01kcg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Scott James Remnant <scott@canonical.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs maintenance disaster
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott James Remnant <scott@canonical.com> writes:

>> I do share frustration with Eric on how Kay and Greg have handled this.
>> It really felt like a combination of bullying, ignoring any contrarian
>> argument and just ramming stuff down. Not at all unlike the original
>> devfs fiasco. It has left me with a pretty bad taste in my mouth and
>> am pretty disappointed; I expected better.
>> 
> I'm not a kernel developer, I'm a plumbing developer, but from my
> outside perspective it seems like the contrary arguments have had a bit
> of an agenda as well and have taken a "must not go in at any cost"
> attitude.
>
> That I find odd.
>
> It's not as if this is critical path, or going in at the expense of
> other functionality or code.  It's just another useful option for people
> who can find a use for it.
>
> Is that really such a tragedy to have?

Ultimately the way devtmpfs seems to be aimed is as a core component
that is non-optional if you use a standard user space.

My goal in reviewing the code has really been to see if I can
understand the problem devtmpfs has been trying to solve, so I could
understand if devtmpfs is a good solution.

I'm persuadable and I would have really liked to see that devtmpfs
at least comes out of the alternatives.

I want to know why for example the following document no longer applies:
http://kernel.org/pub/linux/utils/kernel/hotplug/udev_vs_devfs

What has changed that makes devfs the bees knees all of a sudden.

My object to devtmpfs going in is that Greg KH and Kay seem to be
in an echo chamber and can't seem to hear when people talk about
bugs in devtmpfs.  So I am not prepared to extend Greg and Kay the
benefit of the doubt any more.

Eric


