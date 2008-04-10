Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYDJAgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYDJAgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYDJAgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:36:14 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60503 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYDJAgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:36:13 -0400
Subject: Re: Does Linux have plan to support memory hole remapping?
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>,
       Zhao Forrest <forrest.zhao@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       ak@suse.de
In-Reply-To: <20080409085440.GB32466@elte.hu>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
	 <87iqyro3rc.fsf@basil.nowhere.org>
	 <20080409083700.GU3700@mea-ext.zmailer.org>
	 <20080409085440.GB32466@elte.hu>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 02:34:47 +0200
Message-Id: <1207787687.30698.97.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 10:54 +0200, Ingo Molnar wrote:
[..]
> 
> having said that - but we'll still consider sane looking patches that 
> allow the remapping of otherwise inactive RAM. [ We might not even have 
> to touch the system chipset beyond what Linux already knows about it: in 
A somewhat related question is.. How come linux does not(as i understand
it) support talking to the chipsets to do these things? wouldnt this
also give other benefits, such as being able to more precisely control
interrupts and stuff?

> theory someone might want to try a hack to GART remap such RAM areas and 
> use a sparse mem map entry to map it to Linux - if the identity of that 
> RAM is crystal-clear and there's enough GART space available. But even 
> then it's probably still at best a dangerous and fragile hack. ]
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

