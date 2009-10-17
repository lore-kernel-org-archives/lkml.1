Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZJQPgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZJQPgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 11:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZJQPgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 11:36:02 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47147 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZJQPgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 11:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uZeFLjYHmMlm+986WxhPoKAaKarw2VVKnsTbLi0Xubf4pPZr0ZdRP7eUu0yhLA1SmC
         yVPZnhyLd7WMipyp17GlwLleVTaAk6Q8CbcmiIURpM3Bx6UqR6b9g4rQnnYav6Ac2t0T
         G5tPMBsMsQDWFvBigg0U8HC5wRIxuG6feQ29Y=
Message-ID: <4AD9E45C.2080807@gmail.com>
Date: Sat, 17 Oct 2009 17:35:56 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>, alan@linux.intel.com,
       stable@kernel.org, stable-commits@vger.kernel.org,
       =?ISO-8859-1?Q?=22Fr=E9?=
	 =?ISO-8859-1?Q?d=E9ric_L=2E_W=2E_Meunier=22?= <fredlwm@gmail.com>,
       linux-kernel@vger.kernel.org, Boyan <btanastasov@yahoo.co.uk>
Subject: Re: patch pty-quickfix-for-the-pty-enxio-timing-problems.patch added
 to 2.6.31-stable tree
References: <20091015184454.5BEDB48B35@coco.kroah.org> <alpine.LFD.2.01.0910151450420.6146@localhost.localdomain> <20091015215459.GA11142@suse.de> <alpine.LFD.2.01.0910151502020.6146@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910151502020.6146@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 15 Oct 2009, Greg KH wrote:
>> Hm, ok, Marcin asked that I include this patch as it fixed his keyboard
>> problems with X on 2.6.31.
>>
>> Marcin, any ideas?
> 
> Get current -git, I think it shoul be fixed there properly.
> 
> Marking the pty's "low_latency" works around the problem, but will break 
> at least ppp.
> 
> 		Linus

Greg, I see you queued c8e33141911bf8fe87dc6c92793b9a59b2be0130
(tty: Make flush_to_ldisc() locking more robust) for stable, so I guess
you figured out it was not my problems with keyboard (*), but Boyan's
and Frédéric's.

* http://lkml.org/lkml/2009/10/12/465

Marcin

