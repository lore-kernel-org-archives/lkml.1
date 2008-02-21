Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbYBUHbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbYBUHbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbYBUHbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:31:00 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:65090 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYBUHa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:30:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=khPQQoKzqqhe1qbj028A+UvX8RSylDz34UYaWvwiF7xY4/bu210xJ0AuyWpTEXX74WoXzJ1gjDwz4lQo/nXbZe2qp+8nvsO63ysh7mYHXuEYD9LkX0OVV+CL/h5VMtdxA1qDC6s82U6XpKom0X8TaaUn2vCLfE191cK7U1B0C0Q=
Message-ID: <a8e1da0802202330q67f7b5ffo1258b08b043a6ac3@mail.gmail.com>
Date: Thu, 21 Feb 2008 15:30:58 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: Kernel oops with bluetooth usb dongle
Cc: "Marcel Holtmann" <marcel@holtmann.org>, "Quel Qun" <kelk1@comcast.net>,
       LKML <linux-kernel@vger.kernel.org>, "Jiri Kosina" <jkosina@suse.cz>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.00.0802200908250.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <021820080001.29293.47B8CAD10009FD170000726D2207000953CE05040A05@comcast.net>
	 <alpine.LFD.1.00.0802181245370.7583@apollo.tec.linutronix.de>
	 <895FB10F-5E5C-4409-AC3E-5F83BBF9ED72@holtmann.org>
	 <alpine.LFD.1.00.0802200108040.7583@apollo.tec.linutronix.de>
	 <alpine.LFD.1.00.0802200908250.7583@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 4:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 20 Feb 2008, Thomas Gleixner wrote:
>  > On Tue, 19 Feb 2008, Marcel Holtmann wrote:
>
> > > I don't really have any idea. Nothing has been changed in this area for a
>  > > couple of years. The command TX timeout is the timeout that indicates a
>  > > missing answer to a command sent down to the Bluetooth chip.
>  > >
>  > > However this involves some atomic and tasklet stuff. Did we have some changes
>  > > that I missed and might now render this usage as broken.
>  >
>  > Not that I'm aware off, but this might as well be some old use after
>  > free bug which got exposed by some unrelated change. The good news is
>  > that it is reproducible. I'll hack up some nasty debug patch which
>  > lets us - hopefully - decode where the timer was armed.
>
>  Quel, before I do that, is there any chance that you retest with the
>  latest mainline git version ?
>
>  http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc2-git4.bz2

And please test with this patch as well:

http://lkml.org/lkml/2008/2/20/121

>
>  Is the delta which applies on top of rc2.
>
>
>
>  Thanks,
>
>         tglx
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
