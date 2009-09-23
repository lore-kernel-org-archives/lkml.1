Return-Path: <linux-kernel-owner+w=401wt.eu-S1751289AbZIWMdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbZIWMdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZIWMdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:33:14 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:47764 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZIWMdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:33:13 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 08:33:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iCBF5NJJHSrhxpgUAFv/Ssl3uxx1n4iyT51nhvYdKMFXDvLBQzx5jviskiG+sJtOKl
         iHVQgAcrdunSV0FNbjDquxKu8G3rtyaPm+cXO/xnLfE9ufqNUfwz/xFHG4VcDkW3MGPn
         PRJkKX8KQEbGrkgB30LEKeFjaWQANyiThJ5d0=
MIME-Version: 1.0
In-Reply-To: <1253708392.5631.408.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
	 <1253617510.7695.23.camel@twins> <1253623867.20345.156.camel@Palantir>
	 <1253644603.18939.25.camel@laptop>
	 <1253708392.5631.408.camel@Palantir>
Date: Wed, 23 Sep 2009 17:55:28 +0530
Message-ID: <8aa016e10909230525v55a2d473v55f78c982297f6dc@mail.gmail.com>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> An alternative is starting the child out with 0 runtime, and have the
>> parent run sched_setscheduler() on it giving us a clear point to run
>> admission on.
>>
> I thought this too, we just have to chose whether the 'more natural' or,
> let's say 'user friendly', behaviour is...
>

I agree with Peter here. It makes more sense to start it with a 0
runtime, because anyway whenever you will fork, you will be under
controlled conditions and know how much bandwidth you need. I think we
should just let userspace handle this part.

Thanks,
Dhaval

-- 

Marie von Ebner-Eschenbach  - "Even a stopped clock is right twice a
day." - http://www.brainyquote.com/quotes/authors/m/marie_von_ebnereschenbac.html
