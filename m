Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbZIRWDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbZIRWDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 18:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbZIRWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 18:03:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45969 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702AbZIRWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 18:03:09 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org>
	<20090917185306.GA28635@elte.hu>
	<ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>
	<alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
	<ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
	<alpine.LFD.2.01.0909171709410.4950@localhost.localdomain>
	<1253238637.4071.10.camel@yio.site> <m14or0vul4.fsf@fess.ebiederm.org>
	<1253309513.1864.5.camel@yio.site>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Sep 2009 15:03:04 -0700
In-Reply-To: <1253309513.1864.5.camel@yio.site> (Kay Sievers's message of "Fri\, 18 Sep 2009 23\:31\:53 +0200")
Message-ID: <m1hbuzc3mv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Fri, 2009-09-18 at 13:58 -0700, Eric W. Biederman wrote:
>> As a special case you can implement this much
>> more simply in devtmpfs_mount just do:
>
> I sent the patch to Greg already. I like to keep the things in the
> subsystem where the non-default names are set. The issue will come back
> from the embedded guys, who want to do be able to do that for a few more
> nodes and run their stuff completely without userspace /dev. We are also
> sure never to touch anything we did not create.

There are a lot of stupid expedient things that people making embedded
products like to do.   Tell them to write a 5 line /sbin/hotplug script.

udev isn't too expensive to run on the embedded platforms, and if they
have enough horse power in the system to run linux udev is almost certainly
a possibility.

> This change works for me here. Do you want to send or sign that off? :)

Nope.   I don't want any piece of ownership of devtmpfs.  I have sent
the only patch I am comfortable with.

Eric
