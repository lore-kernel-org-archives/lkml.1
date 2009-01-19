Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbZASO4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbZASO4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760180AbZASOzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:55:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:14624 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760988AbZASOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=omv0CIau6X3782byXjl8Ho+ihfNzQ/RlgjigHw+PH2Kdv3j9Dv7x4hD+iY/lR7IDg/
         HhC+secn0TnBHHVa1fjJMbyC6Uy+MhwSsZFMrAY0PF912RkwL47+SxyYRH/0cbgDEQuz
         04M2qn2/UwfPmhzsrSd3Xg5Lt17e6akVPW8/Q=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0901132117270.3549@localhost.localdomain>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
	 <nHCfeC0YLrE.A.WKC.qafaJB@chimera>
	 <alpine.LFD.2.00.0901132117270.3549@localhost.localdomain>
Date: Mon, 19 Jan 2009 15:55:09 +0100
X-Google-Sender-Auth: 271fd1bae7c431ba
Message-ID: <a5d587fb0901190655o76688b2ar667861f75e94436f@mail.gmail.com>
Subject: Re: [PATCH] x86: vm86: fix preemption bug
From: Michal Suchanek <hramrach@centrum.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/2009, Thomas Gleixner <tglx@linutronix.de> wrote:
> Impact: fix scheduling while atomic bug
>
>  commit 3d2a71a596bd9c761c8487a2178e95f8a61da083 (x86, traps: converge
>  do_debug handlers) changed the preemption disable logic of do_debug()
>  so vm86_handle_trap() is called with preemption disabled resulting in:
>

The patch seems to fix the the problem for me.

However, the patch does not apply automatically neither to 2.6.28 nor
2.6.29-rc1.

Thanks

Michal
