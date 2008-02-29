Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYB2GZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYB2GZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYB2GZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:25:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:64342 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbYB2GZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XzDCf7oA/LEAUH17wEhTOelP/bn/Rj3zrgcdzLe/HRumKlTsjV6NrOFa8HQs36MJQH1TIhgT4nkADpXC/h5K9I3kVhoPecxwNm3EXobdJOYXYzNrtaRCtVYiZtltAa77JBqDx79qdrvN9ks9nStCHYrkJeaLjfRBxs6O9fOLcpg=
Message-ID: <2c0942db0802282225j7d01eee3vbe6bbb7b93e86e47@mail.gmail.com>
Date: Thu, 28 Feb 2008 22:25:06 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [PATCH] Remove obsolete CLOCK_TICK_ADJUST
Cc: "john stultz" <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0802290547320.2723@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201142334.6383.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802120335170.3378@scrub.home>
	 <1202963796.6195.141.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802150436300.1822@scrub.home>
	 <1203382940.5984.242.camel@localhost>
	 <Pine.LNX.4.64.0802190219360.2723@scrub.home>
	 <1203472250.6123.98.camel@localhost>
	 <Pine.LNX.4.64.0802200348230.2723@scrub.home>
	 <1203647951.6150.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802290547320.2723@scrub.home>
X-Google-Sender-Auth: 1ed733802eab5b8d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 8:49 PM, Roman Zippel <zippel@linux-m68k.org> wrote:
>  Revert bbe4d18ac2e058c56adb0cd71f49d9ed3216a405 and
>  e13a2e61dd5152f5499d2003470acf9c838eab84 and remove CLOCK_TICK_ADJUST
>  completely. Add a optional kernel parameter ntp_tick_adj instead to allow
>  adjusting of a large base drift and thus keeping ntpd happy.

Wait, so you're saying that something that the kernel correctly
figures out on its own today should instead be a kernel parameter,
with users having to supply it explicitly? Am I confused?

If I'm not confused, would you'd be so kind to explain to the peanut
gallery over here why this is a good thing?
