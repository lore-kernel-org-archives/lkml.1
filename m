Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbXLHXhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbXLHXhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 18:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXLHXhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 18:37:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:21971 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbXLHXhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 18:37:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tkmhsRMSSqNMKf8Jv9XjePz1oYfgibxbX2+SUGDOlfqKpY5lUkpkYM7SFX3m4ngCNwUmxtm/M2Z4JFHxSroN0AxFnNtYX2uEIMoT/bdhH5cq+QLnuN/UbIwFV+lLAMqxoOF0WWgyeC1RNoHR/RkNyWV9F8BJpLtAJYw1yCqcv5A=
Message-ID: <3d8471ca0712081537r42535946n56d44f77b27f773@mail.gmail.com>
Date: Sun, 9 Dec 2007 00:37:21 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Stefano Brivio" <stefano.brivio@polimi.it>,
       "Robert Love" <rml@tech9.net>, linux-kernel@vger.kernel.org,
       "Dave Jones" <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Michael Buesch" <mb@bu3sch.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <20071208085207.GE30997@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071207021952.6f0ac922@morte>
	 <200712080348.53117.nickpiggin@yahoo.com.au>
	 <200712081150.50737.nickpiggin@yahoo.com.au>
	 <200712081157.27840.nickpiggin@yahoo.com.au>
	 <20071208085207.GE30997@elte.hu>
X-Google-Sender-Auth: 26959e2b855f76a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 9:52 AM, Ingo Molnar <mingo@elte.hu> wrote:

> the scariest bit isnt even the scaling i think - that is a fairly
> straightforward and clean PER_CPU-ization of the global scaling factor,
> and its hookup with cpufreq events. (and the credit for that goes to
> Guillaume Chazarain)

To be fair, the cpufreq hook were already there, I just did a buggy percpu
conversion and added an offset that you removed ;-)

-- 
Guillaume
