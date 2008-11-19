Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYKSHf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYKSHf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYKSHfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:35:18 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:42785 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYKSHfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:35:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZEvNdrLE/l5pCBrbmEw9vEAN5b2SB64SlFWnfV51NWHGSZgPZGlrVSBiO5XYoo0A/e
         qgN6wO7DX4zUr/XxvHzjI7OiUXVTNnie9brvzz53aU4iigtghmbZjFzbiqaJXskNZ6X1
         A+aZ24gElGNBUsA/+byRM5hnPWyU4/lhR4vcA=
Message-ID: <c62985530811182335i4b5ab4ddhd3bf9ddac0e2cd00@mail.gmail.com>
Date: Wed, 19 Nov 2008 08:35:15 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun field
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081118210344.GC11490@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081118084755.GK17838@elte.hu> <20081118145154.GC30358@elte.hu>
	 <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>
	 <20081118151326.GH30358@elte.hu>
	 <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com>
	 <20081118155045.GJ30358@elte.hu>
	 <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
	 <20081118164019.GA18620@elte.hu>
	 <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com>
	 <20081118210344.GC11490@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/18 Ingo Molnar <mingo@elte.hu>:
> it's your call really, either way is fine as long as the end result
> works! :-)
>
> Generally it's indeed much easier to do as small steps as possible,
> and to validate every step in practice.
>
>        Ingo
>


That's right, I will start with a static array first and end with
dynamic allocation.
I'm not sure if it will be ready for merge window of 2.6.29 but that
doesn't really matter.


> hey, look at the bright side of it: whichever variant you pick, if it
> goes wrong, you'll always have someone else to blame for that
> unbelievably stupid suggestion ;-)
>
>        Ingo
>

Hehe! Indeed :-)
