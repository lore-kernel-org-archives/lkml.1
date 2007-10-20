Return-Path: <linux-kernel-owner+w=401wt.eu-S1765671AbXJTM35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765671AbXJTM35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 08:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXJTM3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 08:29:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:54655 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXJTM3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 08:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=iHbl7IUOLKZDrTpkJ7b4I7vcNkeR3gJccIaNcSCixRjZZ5Hi9qtA7uRBkz1KODDsF+0iqIcwF+Yo7gvO3W0ZZjaP7ofaSXNLVRSA+rrTe4hMaLe3tVjPAXXayal8197z5+y2eBpp8iLPJhC5hKHdnPeuhAqyhjlE3jZiEASgmiw=
Date: Sat, 20 Oct 2007 14:38:07 -0700
To: "eric miao" <eric.y.miao@gmail.com>
Cc: "Kristoffer Ericson" <kristoffer.ericson@gmail.com>,
       "Russell King" <linux@arm.linux.org.uk>,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: PDA Suspend SA1100
Message-Id: <20071020143807.c9677e47.Kristoffer.Ericson@Gmail.com>
In-Reply-To: <f17812d70710181756n67c92f31p7f37eaed88f33aea@mail.gmail.com>
References: <20071019013736.11dec046.Kristoffer.ericson@gmail.com>
	<f17812d70710181756n67c92f31p7f37eaed88f33aea@mail.gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 08:56:18 +0800
"eric miao" <eric.y.miao@gmail.com> wrote:

> On 10/19/07, Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:
> > Greetings,
> >
> > I've been trying to implement proper suspend on my jornada 720 machine. But as far as I can see it never reaches
> > the sa11x0_suspend code.
> >
> > I've linked power button event to produce APM_SUSPEND and I can see that it says "Stopping TASKS ======". It then
> > blanks screen but keeps LCD powerd. I know it goes into resume again since removing backlight code in resume function
> > effectivly turns off the LCD.
> >
> > Im assuming that it tries to suspend but fails at some point and tries to return into normal operations?
> > Exactly what is needed to get the suspend procedure happy? Does every driver need to have suspend/resume code?
> 
> I don't think so. Unless a driver feels it necessary to take some
> action, no suspend/resume
> will not cause the whole system to fail. However,
Ah, good to know.

> 
> 1) if any driver suspend code returns error, the whole procedure will stop
> 2) and instable wake-up source (like glitch on wake-up GPIO pin) or
> incorrect setting (like
> wake up from RTC but set the interval to be 0) will also cause the
> immediate resume
I'll start running through the different drivers to see if I can spot anything obvious.
> 
> check "sa11x0_suspend" print out won't work since the console has already been
> suspended, try DISABLE_CONSOLE_SUSPEND or other ways
> 
> - eric
> 
> >
> > Best wishes
> > Kristoffer Ericson
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >


-- 
Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>
