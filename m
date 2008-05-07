Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbYEGWbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbYEGWbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYEGWbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:31:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:51803 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYEGWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=daBeKVhmplCXKW+Lv9K7RpD9HRzgwK3u/EbLDrWKOpmp0scvRP5PSU2fUIhWpPZPhGO5WjV1s8FJA10pwbYVBdKEBeMjn2QJ5MNOshFcJZa3VNLya6H6WK3+/J3XPsDeq53kxkc1AqFBswstak3e2+G4jsPgSThkVEcktSiqstg=
Message-ID: <86802c440805071531p2803e280r10baaa82c2c75d82@mail.gmail.com>
Date: Wed, 7 May 2008 15:31:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.26, PAT and AMD family 6
Cc: "Rene Herman" <rene.herman@keyaccess.nl>, "Adrian Bunk" <bunk@kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       "Pavel Machek" <pavel@suse.cz>
In-Reply-To: <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48210A71.1060409@keyaccess.nl>
	 <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	 <20080507124650.GD29935@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
	 <48221AE3.6020602@keyaccess.nl>
	 <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 2:41 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 7 May 2008, Rene Herman wrote:
>  > On 07-05-08 22:52, Thomas Gleixner wrote:
>  > You misunderstood. Yinghai's patch only changed one of the code sites
>  > and not the others, which (if I understood right) is the breakage
>  > Adrian was reffering to.
>
>  I know exactly what he was referring to. So what's the problem ?
>
>  Yinghai missed to add it to the other place and he is hardly to blame
>  for that. This code is messy and thats not his fault. It will be
>  cleaned up, but that's not an simple taks to do. If you think you can
>  do it without breaking tons of systems, you're welcome.

yes, i should modify two places in common.c.
but don't need to change the one in setup_64.c because duron is 32 bit only.

YH
