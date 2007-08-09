Return-Path: <linux-kernel-owner+w=401wt.eu-S1760989AbXHITbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760989AbXHITbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbXHITbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:31:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:62189 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXHITba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=APSJJVvJJVQHq8DmRv/4+qIwEHWe2fA3Wnurvxnsaz5m/SfVFF0e0wXygZ8hxrwc4hH/lum8mL40+E2rnEsAwUpzUEWB0ExoY7ZpnFSSX3DPQTXm5ItTql//WEf4ETvW9Ra4I0g2deB37aQ+gT7FTWMKVhwEoNCV00ByCm2lsYg=
Message-ID: <1158166a0708091231r21903840mc927b6baa47e4598@mail.gmail.com>
Date: Thu, 9 Aug 2007 20:31:28 +0100
From: "Denis Vlasenko" <vda.linux@googlemail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] msleep() with hrtimers
Cc: "Roman Zippel" <zippel@linux-m68k.org>, "Jonathan Corbet" <corbet@lwn.net>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       akpm@linux-foundation.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1186546512.2862.3.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15327.1186166232@lwn.net>
	 <1186255149.2777.3.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060150270.1817@scrub.home>
	 <1186360983.2697.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060257010.1817@scrub.home>
	 <1186378798.2697.10.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708061159370.1817@scrub.home>
	 <1186415621.2706.4.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708071417200.1817@scrub.home>
	 <1186546512.2862.3.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Arjan van de Ven <arjan@infradead.org> wrote:
> You keep claiming that hrtimers are so incredibly expensive; but for
> msleep()... which is mostly called during driver init ... I really don't
> buy that it's really expensive. We're not doing this a gazilion times
> per second obviously...

Yes. Optimizing delay or sleep functions for speed is a contradiction
of terms. IIRC we still optimize udelay for speed, not code size...
Read it again folks:

        We optimize udelay for speed

How fast your udelay do you want to be today?

Oh well.
--
vda
