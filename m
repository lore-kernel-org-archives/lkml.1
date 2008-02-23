Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYBWM3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYBWM3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYBWM3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:29:36 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:39380 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYBWM3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:29:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tYfioKuMauc01s4vPZUtoxWWqN3l9sZ9s+1XVQXzBb3/WmSIBiPNGM1dEkFpLrRHKTEOt10qhGvAmiTLBheHkDFXiLd7t4moJfY1tCOEpESLeK7KP5E6jR3e9T6x7/VmybMajxBaA5jSLkFGB2L3qRhgNcCQR1WhrIna1SPDNNc=
Message-ID: <84144f020802230429t181f0503r5629658ca39c699b@mail.gmail.com>
Date: Sat, 23 Feb 2008 14:29:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
In-Reply-To: <20080223122222.GA323@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <20080223001130.d8922136.akpm@linux-foundation.org>
	 <84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com>
	 <20080223122222.GA323@elte.hu>
X-Google-Sender-Auth: 6e53fe4381d2617b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sat, Feb 23, 2008 at 2:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  As a comparison, here's a session of a newbie developer, meeting
>  oprofile for the first time in his life (using a fresh package,
>  oprofile-0.9.3-6.fc8):
>
>   ---------------------->
>   [ Newbie: WTF, no GUI tool? ]
>   [ Narrator: we lose 90% of the developers at this point. ]

In all fairness, there's a GUI for oprofile too [1] but I don't think
it supports call trees as sysprof does which is IMHO the killer
feature of the latter.

  1. http://labs.o-hand.com/oprofileui/
