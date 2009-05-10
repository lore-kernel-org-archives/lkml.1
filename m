Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZEJA3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZEJA3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 20:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZEJA3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 20:29:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52258 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZEJA3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 20:29:21 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
References: <1241097822.2516.3.camel@poy> <m1vdodnx8e.fsf@fess.ebiederm.org>
	<ac3eb2510905070228w5ecb5aa9ob24af17a91d2f231@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 09 May 2009 17:29:15 -0700
In-Reply-To: <ac3eb2510905070228w5ecb5aa9ob24af17a91d2f231@mail.gmail.com> (Kay Sievers's message of "Thu\, 7 May 2009 11\:28\:19 +0200")
Message-ID: <m1skjd4x7o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, jblunck@suse.de, greg@kroah.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4937]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Thu, May 7, 2009 at 10:17, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> sysfs is slow.
>> udev is slow.
>
> Everything is "slow" if you want to boot "fast". It's just numbers,
> and this is more about simplicity and reliability, with just the side
> effect that it's the fastest you can do, when you don't want to lose
> current functionality.

My primary concern is that you are inventing a new mechanism when
the existing mechanism has known issues that could explain the slowdowns.

My secondary concern is we have are adding a new mechanism when
the existing mechanism has some significant known issues, that are
not currently being addressed.  Instead the next shiny bobble is
being tackled.

Finally I am stumped how creating a couple hundred device nodes can be
a significant slowdown in booting.  It feels like we your patchset
adds a line of code for each device node it intends to create.

>> Let's bloat the kernel to solve that problem?
>
> You want to add namespaces for devices to it?

I think it is a logical conclusion, and it might potentially be needed.
But that is a long ways out.

Eric
