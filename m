Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZB0DQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZB0DQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZB0DQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:16:16 -0500
Received: from mail.atheros.com ([12.36.123.2]:26791 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZB0DQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:16:15 -0500
Date: Thu, 26 Feb 2009 19:15:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Jiri Slaby <jirislaby@gmail.com>, "proski@gnu.org" <proski@gnu.org>,
       "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090227031525.GG13456@tesla>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com> <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com> <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet> <20090227023912.GF13456@tesla> <20090227030608.GA29974@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090227030608.GA29974@hash.localnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 07:06:08PM -0800, Bob Copeland wrote:
> On Thu, Feb 26, 2009 at 06:39:12PM -0800, Luis R. Rodriguez wrote:
> > Might be worth adding a note why this is the case. Can't we simply avoid
> > this by checking earlier for the error or simply assigning it an actual
> > default _good_ hw rate value?
> 
> I guess an alternative is to initialize to 0, that would count any rx
> packets whose hw rate we don't know about as the base rate, so it would
> probably bias the RC to 1mb, but this is already one of those 'should
> never happen' cases.

Understood.

> Also I can't forsee having a rate index > 127 so
> changing the sign is pretty low risk.

Sure, it just seems a bit strange to see a signed rate index,
that's all. And if its to deal with an error I think it may
be nicer to actually use a rate that works and then warn
rather than warn and not use a valid rate at all.

Mind you I haven't checked this code in while.

  Luis
