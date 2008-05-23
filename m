Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYEWTGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYEWTGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYEWTGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:06:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:27808 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYEWTG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qUTb07hjqWyJoNwsDJNT3ESrZSeDv0e5K6f+mPg6QQrX9Xnt7u3mlUY0qSmuqCKvpExVEdD2MN0t1H1yB/8LF57P41m6JJP1vbsTZ+OrgfqWv19gjs7mSVT//e4s+Z0dt48EICuhthHsGh4EkXQxDEz/G7ZN6+3ToNiQXsM7hsA=
Message-ID: <86802c440805231206n30450bbq4db8200b22f57e41@mail.gmail.com>
Date: Fri, 23 May 2008 12:06:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Enable mmconf access to PCI ECS for all AMD fam10h systems
Cc: "Robert Richter" <robert.richter@amd.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080523111825.580423e1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523124622.GV27511@erda.amd.com>
	 <86802c440805231057v659e5c7ahfd0407d46ef34bfd@mail.gmail.com>
	 <20080523111825.580423e1@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 11:18 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 23 May 2008 10:57:22 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>> On Fri, May 23, 2008 at 5:46 AM, Robert Richter
>> <robert.richter@amd.com> wrote:
>> > Yinghai,
>> >
>> > We would like to enable ECS for all fam10h systems. What was the
>> > reason for patch 5f0b2976 that enables it for Sun systems only? If
>> > there are no objections, this patch should be reverted.
>>
>> Someone express the concern about touching MSR. Arjan or Andi?
>>
>> for those of system that doesn't have MCFG table there, they could use
>> pci=check_enable_amd_mmconf to enable it forcely.
>
> using MMIO if the bios doesn't allow it via MCFG is a huge mistake and
> shouldn't be done.
>
> Using the extended port IO version is actually perfectly reasonable to
> me and I would encourage that to be in the kernel (and be used in favor
> of MCFG if the port IO method is there)

that extend access via port IO on AMD Fam10h doesn't support pci
domain other than domain 0.

YH
