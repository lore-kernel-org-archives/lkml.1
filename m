Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZDDPbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZDDPbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 11:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZDDPa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 11:30:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33939 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbZDDPa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 11:30:57 -0400
From: Jon Masters <jcm@redhat.com>
To: Clark Williams <williams@redhat.com>
In-Reply-To: <20090402151621.171a95c9@torg>
Subject: Re: [PATCH 1/2] SMI Detector: a simple module for detecting System Management Interrupts
References: <1238691005-25286-1-git-send-email-jcm@jonmasters.org> <1238691005-25286-2-git-send-email-jcm@jonmasters.org> <c62985530904021205t2030c81o3d6439ab6a3a5e1e@mail.gmail.com> <20090402151621.171a95c9@torg>
Message-Id: <8E9A4CF2-4B18-41FD-8E16-521DF00E4305@redhat.com>
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (iPhone Mail 5H11)
Date: Sat, 4 Apr 2009 09:28:39 -0600
Cc: =?utf-8?Q?Fr=C3=A9d=C3=A9ric_Weisbecker?= <fweisbec@gmail.com>,
       Jon Masters <jcm@jonmasters.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Clark and Frederic. I am currently on a train going through the  
Rockies but will send an update tomorrow. Sorry for top posting.

Jon.



On Apr 2, 2009, at 14:16, Clark Williams <williams@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On Thu, 2 Apr 2009 21:05:26 +0200
> Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>
>>> +#if 1
>>> +       val = simple_strtol(buffer, NULL, 10);
>>> +#else
>>> +       if (strict_strtol(buffer, 10, &val))
>>> +               return -EINVAL;
>>> +#endif
>>
>>
>>
>> So I guess the #else statement can disappear? :-)
>>
>>
>
> Ugh, don't blame Jon for that. I was trying to get rid of some
> checkpatch warnings and was experimenting with strict vs. simple
> strtol.
>
> I'll clean that up in the next iteration. Or Jon can and will then
> abuse me :)
>
> Clark
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.9 (GNU/Linux)
>
> iEYEARECAAYFAknVHRoACgkQHyuj/+TTEp0ndwCfe4ZeEsdflVY3udv9ukk7wKVQ
> OycAn1Nl1OQr7nPUxPp3rln5SYVE4Bcn
> =kZRN
> -----END PGP SIGNATURE-----
