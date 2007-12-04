Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbXLDQ5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbXLDQ5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbXLDQ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:56:57 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:8225 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbXLDQ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:56:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tUm206JiicLXd98mwv9Xbv9QIuOM0eIpLxK8GT5A9D5K0D+OT0xeyHP2Lupkhwe0PWy0xOEePgyNWsqWK77VAUu+zSyubBLZTKPKu9djatkKCY2c3DQClfBcdA/cXOhcb5QJdhF6R72tclUVD3+IWOB/EKufLM3n3sgnfiY6Hh8=
Message-ID: <8bd0f97a0712040856j530c1389l82adafcba07b89ae@mail.gmail.com>
Date: Tue, 4 Dec 2007 11:56:54 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Alessandro Zummo" <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 1/7] Blackfin RTC driver: the frequency function is in units of Hz, not units of seconds, so lock our driver down to 1 Hz
Cc: rtc-linux@googlegroups.com, "Bryan Wu" <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
In-Reply-To: <20071204174947.5c468e3d@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
	 <1195812512-25979-2-git-send-email-bryan.wu@analog.com>
	 <20071204172634.50492e1e@i1501.lan.towertech.it>
	 <8bd0f97a0712040829i116496deu384453c6eccfa252@mail.gmail.com>
	 <20071204174146.19bedb54@i1501.lan.towertech.it>
	 <8bd0f97a0712040847m73bb479dx814d83985e5223d5@mail.gmail.com>
	 <20071204174947.5c468e3d@i1501.lan.towertech.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 11:49 AM, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> On Tue, 4 Dec 2007 11:47:56 -0500
> "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> > the return of ENOTTY is to say "changing of freq isnt supported", not
> > that the value is invalid.  but i can get the same behavior by
> > deleting the function as the rtc-dev layer will take care of returning
> > ENOTTY.
> >
> > so the behavior is for the RTC_IRQP_SET ioctl:
> >  - return ENOTTY if you cannot change freq
> >    - the rtc-dev layer will do this for you if you do not set irq_set_freq
> >  - return EINVAL if the requested freq is not within the capabilities
> > of the hardware
> >
> > sound about right ?
>
>  yes, it is. I agree about deleting it.

so, merge this patch and i'll follow up with another to delete the
func and update the documentation ?
-mike
