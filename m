Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZIWPjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZIWPjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZIWPjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:39:42 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:62675 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZIWPjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sYwuEbCPvssq1/gh0T7IaQyCbpyZDiEaVzlnOgCdxwQ2MhBXN/uH/6sio1yEdqw0hf
         TgvAbPRkv/HpMBrA8bg4dUlkmYa7bdKkA2YnjzLDbxq5hRKwSgY3xixw8KCXJrIrOQYr
         ekGUtGT2QKL5r9mnK+LGFiFjQ/JHhvj5vQH2w=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
	 <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
	 <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
	 <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
	 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
	 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
Date: Wed, 23 Sep 2009 17:39:44 +0200
X-Google-Sender-Auth: 5c768d701c001cdd
Message-ID: <4de7f8a60909230839j3d6beca8l9a677d38bc3a80d3@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31-rt11
From: Jan Blunck <jblunck@suse.de>
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
       Darren Hart <dvhltc@us.ibm.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 12:39 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
>
>   - disable SPARSE_IRQ, DMAR, IRQ_REMAP for -rt
>

Do you have any reports that there is a bug in the SPARSE_IRQ code or
why did you disable it?

Thanks,
Jan
