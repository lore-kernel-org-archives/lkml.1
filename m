Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZEGUA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZEGUA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZEGUAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:00:17 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:53137 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbZEGUAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:00:15 -0400
X-Greylist: delayed 1386 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 May 2009 16:00:15 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pOVYwJGPPYVD/WYK/LEhATfnyqp3dY+IuNJUCYTY4NXtFA/uhrtTudB73Sg73DLzHV
         hhL1CFfZszYfMOQiWcNllKNaFsX52H7C57rhatkFqRhFXeFTfFwiMEK/f63tywDSkW3m
         grY/2TOx2Hq1oQD4usmg0h+vW55LWCNB3bVAI=
MIME-Version: 1.0
In-Reply-To: <20090507180732.27407.qmail@science.horizon.com>
References: <4A02C2A7.4033.ED06D54@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
	 <20090507180732.27407.qmail@science.horizon.com>
Date: Thu, 7 May 2009 12:37:05 -0700
X-Google-Sender-Auth: 54c4d368f9f502db
Message-ID: <1f1b08da0905071237n565154e8x9a9619942fde7703@mail.gmail.com>
Subject: Re: [RFC][PATCH] Adjust SHIFT_PLL to improve NTP convergence.
From: john stultz <johnstul@us.ibm.com>
To: George Spelvin <linux@horizon.com>
Cc: ulrich.windl@rz.uni-regensburg.de, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, williams@redhat.com, zippel@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 11:07 AM, George Spelvin <linux@horizon.com> wrote:
> - If there were some mechanism to make the divisor consistent across
>  boots, that would be helpful.  Imagine a file in /sys that I could
>  write with an absolute frequency at boot time as long as it was within
>  1000 ppm (0.1%) of the kernel's measurement.
>
> Thinking about it, the third option seems the most useful.  It's
> basically a cleaned-up tickadj.

Indeed. Something similar to the lpj= boot option might be nice. I'll
take a look at that.

thanks
-john
