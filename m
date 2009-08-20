Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZHTCTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZHTCTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZHTCTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:19:06 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:64141 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZHTCTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tOk9zsnVcSWY/Gq8o8Al2zWM+6mVY1vPmuFFukNRR6r6qzKqsq0/Bw8KmTwYkhTTcp
         SLw1/xYpWmQTwifuGA0ZoC64GnPdxM9by5WaK3/3Igq1AR9cthMDx8C0kCiO6Tn1E4V/
         sH3gtwjpUjjHtfKFn1F89QaBew9jreEc9+CFw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
	 <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
Date: Wed, 19 Aug 2009 19:19:02 -0700
X-Google-Sender-Auth: 852ef999a0568387
Message-ID: <1f1b08da0908191919x77c8e9edu9f31a9a56ba41ee@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc6-rt5
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Dinakar Guniguntala <dino@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 2:48 PM, Thomas Gleixner<tglx@linutronix.de> wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.

Hey Thomas, Peter, Ingo,
    I'm still seeing the odd SMP scheduler behavior (where all the
processes line up on a single cpu) with -rt5. This can be easily
reproduced with a "make -j8 bzImage".  I'm I the only one seeing this?
 Any suggestions on further debugging this?

thanks
-john
