Return-Path: <linux-kernel-owner+w=401wt.eu-S932640AbXJPFwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbXJPFwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbXJPFv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:51:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:22610 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbXJPFvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AVcQ7xGWdh8kY8pCwPBKmHXighYC2gEvTo/o/4ZFLUwcAKKxb3iV34cvjMcPcRsVxF8WQ6uHoLcNtTOtlojIrxOgdQ2y9mbMVB90lhaQLc9OmWn+smcbpQ7VkJk+JKdaoXkrG22i7vlPWWybWQOO9gJpyq27DiWwWQoNpVqfUfw=
Message-ID: <386072610710152251k66529210x9311d2f2b202ad2b@mail.gmail.com>
Date: Tue, 16 Oct 2007 13:51:53 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH try #3] Input/Joystick Driver: add support AD7142 joystick driver
Cc: bryan.wu@analog.com, "Andrey Panin" <pazke@donpac.ru>,
       "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <d120d5000710151040n2dbea5cbt515d3df87d5d19ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192459625.6215.17.camel@roc-laptop>
	 <d120d5000710150848t1993b0aavbbc0cd7971e3ef3e@mail.gmail.com>
	 <386072610710151024s13e9c16qd7c974cde8000a9@mail.gmail.com>
	 <d120d5000710151040n2dbea5cbt515d3df87d5d19ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On 10/15/07, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> > On 10/15/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > >
> > > Completion is just not a good abstraction here... Please use work
> > > abstraction and possibly a separate workqueue.
> >
> > Yes, I agree with you now, although I have a little concern about the
> > possibility of big delay introduced by workqueue.
> >
>
> Having a separate workqueue should isolate the driver from users
> hogging keventd. Otherwise the speed should be pretty much the same as
> with a kthread.
>

Does this driver need the create a new kthread instead of keventd?
I think keventd might be sufficient for this driver.

> >
> > Thanks a lot for you kindly review.
> > I will resend update patch later.
>
> Thank you for not getting frustrated with all my change requests.

Oh, your help is very useful. It encourages us to send out our drivers
to LKML.

> Btw,
> blackfin keypad driver is in my tree and should be in mainline once
> Linus does the pull I requested.
>

Thanks again, I noticed it was merged already.

-Bryan Wu
