Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYE2Cxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYE2Cxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 22:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYE2CxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 22:53:22 -0400
Received: from hs-out-0708.google.com ([64.233.178.251]:54256 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYE2CxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 22:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WdxUlfX8T66EFeITOOxqBiwyC+TMqXbYWeAC2Z/YzpJEDhjt5BoOOjBntvmO9eDv7lR2J17AuT3O6wge7VvvxzPRQcFvJZ9Uj9CUTeKU/bTODoq2iQnHE2csC4glWpjF3tmT5qVCfL5YcS+SNJxkGLX+bGCoLMIv8Ngf2Ck8npE=
Message-ID: <514e099a0805281953y53f1e1f5wf900c1d9249a7e56@mail.gmail.com>
Date: Wed, 28 May 2008 19:53:19 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Dave Jones" <davej@redhat.com>, "Jiri Slaby" <jirislaby@gmail.com>,
       "S K" <nospamnoham@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Problem activating multiple cores ONLY if I press any key before kernel is loaded
In-Reply-To: <20080528183510.GA10543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <514e099a0805252039r68f88ac1wbdd1b4de77a9af94@mail.gmail.com>
	 <483A6F94.5070901@gmail.com> <20080528183510.GA10543@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah! I see you are from Redhat. So who, if any, would be likely to fix this?

This might not be the right list to ask this question, but since I
already started a thread -- how do I make sure the same config options
as the Fedora 9 kernel are turned on when I make a vanilla kernel
build? Well other than checking each one individually in menuconfig.

Thanks,
SK

On Wed, May 28, 2008 at 11:35 AM, Dave Jones <davej@redhat.com> wrote:
> On Mon, May 26, 2008 at 10:06:44AM +0200, Jiri Slaby wrote:
>  > On 05/26/2008 05:39 AM, S K wrote:
>  > > and Fedora 9 with kernel 2.6.25.3-18.fc9.i686.
>  > [...]
>  > > I see this in dmesg:
>  > > CPU 1 irqstacks, hard=c07ba000 soft=c079a000
>  > > Not responding.
>  > > Inquiring remote APIC #1...
>  > > ... APIC #1 ID: failed
>  > > ... APIC #1 VERSION: failed
>  > > ... APIC #1 SPIV: failed
>  > > CPU #1 not responding - cannot use it.
>  > > Booting processor 1/2 ip 4000
>  > > Not responding.
>  > > Inquiring remote APIC #2...
>  > > ... APIC #2 ID: failed
>  > > ... APIC #2 VERSION: failed
>  > > ... APIC #2 SPIV: failed
>  > > CPU #2 not responding - cannot use it.
>  > > Booting processor 1/3 ip 4000
>  > > Not responding.
>  > > Inquiring remote APIC #3...
>  > > ... APIC #3 ID: failed
>  > > ... APIC #3 VERSION: failed
>  > > ... APIC #3 SPIV: failed
>  > > CPU #3 not responding - cannot use it.
>  > > Total of 1 processors activated (5015.39 BogoMIPS).
>  > > ENABLING IO-APIC IRQs
>  > > ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
>  > > Brought up 1 CPUs
>  >
>  > Does it work with vanilla? If yes, contact your kernel provider (redhat bugzilla).
>
> Incredibly high chance that the answer is yes.
> I don't recall any patches that could affect this, and in honesty filing
> this at rh bugzilla is going to make me scratch my head, and then
> ask people here like tglx & ingo to take a look, so other than for tracking
> purposes, it's not likely to improve chances of it getting fixed.
>
>        Dave
>
> --
> http://www.codemonkey.org.uk
>
