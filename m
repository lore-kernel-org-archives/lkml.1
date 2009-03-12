Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZCLSYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZCLSYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZCLSYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:24:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:28151 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbZCLSYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EMVnv3sHK7gk1jsEJ4HNtnJLYMPlYqoWDaewFUr/7BD3LbhHOJX8VlH/zx8C+z9hER
         290aI3GENROWZ9bLopqf7BicOY/Ve+7ILtRaX6ggzf6NuzXCl7Fn3aU/fM92xV8uW5iJ
         M51i1YRRU6o916xh3BVRifQ7rAAa5QLyaiGRI=
MIME-Version: 1.0
In-Reply-To: <20090312114121.GF20716@alberich.amd.com>
References: <20090311150027.GK10490@alberich.amd.com>
	 <86802c440903120101o2a0c1ad0iec395c45f782078a@mail.gmail.com>
	 <20090312114121.GF20716@alberich.amd.com>
Date: Thu, 12 Mar 2009 11:24:12 -0700
X-Google-Sender-Auth: 8463451f0aaadd78
Message-ID: <86802c440903121124o10439dcdvf8b9fa0b37c62062@mail.gmail.com>
Subject: Re: [PATCH] x86: mtrr: don't modify RdDram/WrDram bits of fixed MTRRs
From: Yinghai Lu <yinghai@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       trenn@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 4:41 AM, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> On Thu, Mar 12, 2009 at 01:01:26AM -0700, Yinghai Lu wrote:
>> wonder if you could add one dmi check to tell the user that bios is
>> buggy, ask vendor fixed BIOS
>> and skip fixed mtrr sync.
>
> There seem to be several systems affected that do not hide
> RdMem/WrMem bits from OS.
>
>  (Causing Suspend/resume problem:)
> - Acer Ferrari 1000
> - Acer Ferrari 5000
>  (Causing kernel freeze:)
> - Asus M51TR-AP003C notebook
> - Asus M51Ta notebook
> - Asus M3A-H/HDMI mobo

they didn't run bios testsuite or bios testsuite miss that checking?

YH
