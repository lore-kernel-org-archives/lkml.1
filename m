Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYIINKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYIINKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYIINKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:10:30 -0400
Received: from scing.com ([217.160.110.58]:49371 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbYIINKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:10:30 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Tue, 9 Sep 2008 15:10:26 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <200809091153.49184.j@jannau.net> <20080909123335.GA27260@Chamillionaire.breakpoint.cc>
In-Reply-To: <20080909123335.GA27260@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091510.26418.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 14:33:35 Sebastian Siewior wrote:
> * Janne Grunau | 2008-09-09 11:53:48 [+0200]:
> >> >+
> >> >+	bytes_in_key = p->code_length/8 + (p->code_length%8 ? 1 : 0);
> >>
> >> did you actually pass checkpatch.pl ?
> >
> >yes, and while this is ugly I see no obvious CodingStyle violation.
> >
> >is following better?
> >
> >bytes_in_key = p->code_length/8;
> >if (p->code_length%8)
> >	bytes_in_key++;
>
> bytes_in_key = p->code_length / 8;
> if (p->code_length % 8)
> 	bytes_in_key++;
>
> I meant the missing spaces around / and %. Looking now at it, it
> seems that it behaves like DIV_ROUND_UP(). The magic of spaces :)

There is also BITS_TO_LONGS(x) which does the intended. I found it only 
since it uses DIV_ROUND_UP. Will use that. Thanks.

Janne
