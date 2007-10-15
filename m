Return-Path: <linux-kernel-owner+w=401wt.eu-S1765978AbXJORkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765978AbXJORkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbXJORkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:40:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:53605 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303AbXJORkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d2Ey0Cio6G5MiSO5l1vYhc15r8RR6VS5f5eqZdqLXMLfMhM3YlfJPwh5uav0I6gDN79SBqCz2v9TYTcWuo0ga4/zGuG28VXigtnmAYBpilIudVKSPlouOQ2ymDOkoqzUUdFW7bMgw/8csllmhwZYVrFe3na9W5bR/3eWHDDlnkc=
Message-ID: <d120d5000710151040n2dbea5cbt515d3df87d5d19ed@mail.gmail.com>
Date: Mon, 15 Oct 2007 13:40:42 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: [PATCH try #3] Input/Joystick Driver: add support AD7142 joystick driver
Cc: bryan.wu@analog.com, "Andrey Panin" <pazke@donpac.ru>,
       "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <386072610710151024s13e9c16qd7c974cde8000a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192459625.6215.17.camel@roc-laptop>
	 <d120d5000710150848t1993b0aavbbc0cd7971e3ef3e@mail.gmail.com>
	 <386072610710151024s13e9c16qd7c974cde8000a9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/07, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> On 10/15/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> >
> > Completion is just not a good abstraction here... Please use work
> > abstraction and possibly a separate workqueue.
>
> Yes, I agree with you now, although I have a little concern about the
> possibility of big delay introduced by workqueue.
>

Having a separate workqueue should isolate the driver from users
hogging keventd. Otherwise the speed should be pretty much the same as
with a kthread.

>
> Thanks a lot for you kindly review.
> I will resend update patch later.

Thank you for not getting frustrated with all my change requests. Btw,
blackfin keypad driver is in my tree and should be in mainline once
Linus does the pull I requested.

-- 
Dmitry
