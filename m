Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbZIRTeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbZIRTeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbZIRTd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:33:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47616 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbZIRTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:33:58 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	<m1d45oxsrk.fsf@fess.ebiederm.org>
	<20090918160944.58e5c1f5@infradead.org>
	<ac3eb2510909180711k223aeb6ena2de3645317d03bd@mail.gmail.com>
	<20090918162503.6735cc1b@infradead.org>
	<ac3eb2510909180732s6efc97b0o7b25d8da222088ca@mail.gmail.com>
	<20090918164331.24403a5d@infradead.org>
	<ac3eb2510909180758u2131ae0eo9030a97cdde75bc6@mail.gmail.com>
	<20090918171328.7a102223@infradead.org>
	<ac3eb2510909180832h13c636bfxcd93b226fcbe8bb5@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Sep 2009 12:33:54 -0700
In-Reply-To: <ac3eb2510909180832h13c636bfxcd93b226fcbe8bb5@mail.gmail.com> (Kay Sievers's message of "Fri\, 18 Sep 2009 17\:32\:18 +0200")
Message-ID: <m1k4zwvyhp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs  maintenance disaster
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As for losetup.  Arguably the right way to handle that one is the old
fashioned way:

mknod /dev/loop0
losetup /dev/loop0

In that case the kernel calls modprobe for us.  I don't see why we should
have a race in the first place. Even calling modprobe explicitly seems
like a hack in this case.

Eric

