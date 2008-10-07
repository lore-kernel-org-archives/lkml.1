Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYJGX57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYJGX57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJGX5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:57:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:63401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYJGX5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:57:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=UgQjx5/NDC5tVVlhIxn0i0AR45SbURipemuyl4ZgdZeSBS8UQENIx5ka8jfhalMiJY
         GspHDPS1ebzKrWHgzIrDQP51Ush9HzT9WxXP6yKtMOm1R/EotDD4c41a7If6Kt4E5kqU
         VYtrn8hOPdgDHQBzbzQjrm4MNkopRpyVlHDPc=
Message-ID: <7c86c4470810071657l691a2319uc3edbe8ec7c473b7@mail.gmail.com>
Date: Wed, 8 Oct 2008 01:57:45 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: NMI watchdog setup_lapic_nmi_watchdog() problem
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, "Shaohua Li" <shaohua.li@intel.com>
In-Reply-To: <20081007234529.GC7971@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810070845w1346107cx211148c52fd03b68@mail.gmail.com>
	 <20081007132158.009669d2.akpm@linux-foundation.org>
	 <7c86c4470810071410u205fe7c4n43f9dbb76e49812e@mail.gmail.com>
	 <20081007234529.GC7971@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Oct 8, 2008 at 1:45 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> If you remove the 'cheap hack', disabling/enabling works. That's why
>> I'd like to better
>> understand was is going on with suspend/resume.
>
> The hack was done because there wasn't an available CPU global enable flag
> for the nmi watchdog. So resume would possible reenable it unnecessarily
> If there was one it could just check that.
>
I am not sure what you mean by 'CPU global enable flag'.

Are you talking about a per-cpu variable or a truly global variable?

Isn't that what nmi_active is today?

As for per-cpu, there is wd_enabled.
