Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYFXIBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYFXIBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYFXIBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:01:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:5666 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYFXIBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rZyZhuZJr2pkHb+3CCXJPnLnSOpPqbuTAuby5TozdmLd3MtIvLFjHU/OembmXlMyiS
         FJQtfC99P7HSB/584nhHHR4az7jzO2KeMrUhtdsoa1OFC363ep3VEqILjXr55P/IBJlz
         ETfZG1m2lTIkCRtPqXetZ3OI78SzSTSRdKct4=
Message-ID: <e2e108260806240101u30f85da8w7404e52f189f8d9@mail.gmail.com>
Date: Tue, 24 Jun 2008 10:01:08 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Cc: "Roman Zippel" <zippel@linux-m68k.org>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <cfd18e0f0806232239w78546747p8fb899f614c89496@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E00CD.9060503@gmail.com>
	 <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
	 <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
	 <Pine.LNX.4.64.0806231438130.6791@localhost.localdomain>
	 <cfd18e0f0806232239w78546747p8fb899f614c89496@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 7:39 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> I'll add some text (not quite sure what yet) in the nanosleep() man
> page on this point.

You could e.g. mention that nanosleep() is neither affected by the
settimeofday() system call nor by adjtimex() (this last one is used by
ntpd).

Bart.
