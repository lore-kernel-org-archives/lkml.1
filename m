Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYIIMds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYIIMds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYIIMdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:33:40 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50452 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbYIIMdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:33:39 -0400
Date: Tue, 9 Sep 2008 14:33:35 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Janne Grunau <j@jannau.net>
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080909123335.GA27260@Chamillionaire.breakpoint.cc>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080909074018.GA26076@Chamillionaire.breakpoint.cc> <200809091153.49184.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200809091153.49184.j@jannau.net>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janne Grunau | 2008-09-09 11:53:48 [+0200]:

>> >+
>> >+	bytes_in_key = p->code_length/8 + (p->code_length%8 ? 1 : 0);
>>
>> did you actually pass checkpatch.pl ?
>
>yes, and while this is ugly I see no obvious CodingStyle violation.
>
>is following better?
>
>bytes_in_key = p->code_length/8;
>if (p->code_length%8)
>	bytes_in_key++;
>
bytes_in_key = p->code_length / 8;
if (p->code_length % 8)
	bytes_in_key++;

I meant the missing spaces around / and %. Looking now at it, it seems
that it behaves like DIV_ROUND_UP(). The magic of spaces :)

>
>Janne

Sebastian
