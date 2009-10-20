Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZJTUpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZJTUpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZJTUpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:45:49 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:46351 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbZJTUpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Rjmla5QCHV0neYFxvLHob4Unk2aEEeBviU7FhiJUNew4ZdX5/KsuyXd7kiqwnN6S1P
         7otBRD7fsAHuog7L/FcC08tIocmIsRtWaAyvtL9Iz4Pts1+PCQniB20yf9vIVrqf22Dc
         aiNZX5G0UU2BAr5rtHv8cBdEgtjJa0roU96tI=
MIME-Version: 1.0
In-Reply-To: <85d954180910201227q528ff210v575df8c1f83e9ada@mail.gmail.com>
References: <m3iqe9kj18.fsf@lugabout.jhcloos.org>
	 <85d954180910201227q528ff210v575df8c1f83e9ada@mail.gmail.com>
Date: Tue, 20 Oct 2009 13:45:53 -0700
X-Google-Sender-Auth: 1f3a693596528bef
Message-ID: <1f1b08da0910201345w61f1bb4yb99b5f052ea77ac4@mail.gmail.com>
Subject: Re: [ntp:hackers] ntp-dev-4.2.5p235-RC build failure: MOD_NANO not 
	#defined
From: john stultz <johnstul@us.ibm.com>
To: davehart_gmail_exchange_tee@davehart.net
Cc: James Cloos <cloos@jhcloos.com>, hackers@lists.ntp.org,
       linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 12:27 PM, Dave Hart <davehart@gmail.com> wrote:
> Please see:
>
> https://support.ntp.org/bugs/show_bug.cgi?id=1219
>
> which points the finger at the Linux header and has a reference to:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=505566
>
> titled: timex.h: #define MOD_NANO ADJ_NANO missing

The kernel has already been fixed, but glibc still needs to pick up the change.

See the kernel commit here:
http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=c95b4502ad7fe8f3b9954aec794b00ac0046ab3a

thanks
-john
