Return-Path: <linux-kernel-owner+w=401wt.eu-S934468AbXEHRd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468AbXEHRd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934439AbXEHRd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:33:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:5112 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934437AbXEHRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I5ty3pF8gKI2ZEb39FvaW8ZgEalufEsyvgWFRhoOwOMbLPW6l1TqIPLg3iUqZbqOygvZd7BsTxeavsAIiJla6rSphky9ntcklXQk9eusasUck4U2Jjn5A09ppCsL+itlqQAtaCJSKyoQ7YkfVrJWqyHmIa1ZLsggKlecNSimDV0=
Message-ID: <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
Date: Tue, 8 May 2007 10:33:23 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org> <4638F9BE.8090508@zytor.com>
	 <4638FC39.4010101@goop.org> <4638FE1B.9050901@zytor.com>
	 <46390523.5010809@goop.org> <463909AF.9040205@zytor.com>
	 <20070503045031.GA5794@in.ibm.com>
	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	 <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Yes.  setup.S has always been skipped by bzImage via the kexec path
> unless you explicitly tell /sbin/kexec to use the 16bit entry point.
>
> Is not having a VGA console a new thing, or it something you just noticed?
>
> Eric
>

before the changes, it works well.

with --real-mode, it will reset the machine.
with --reset-vga, i will get

Kernel alive
kernel direct mapping tables up to 100000000 @ 8000-d000

on VGA monitor.

YH
