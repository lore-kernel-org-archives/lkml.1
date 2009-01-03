Return-Path: <linux-kernel-owner+w=401wt.eu-S932519AbZACWyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbZACWyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZACWyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:54:35 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36874 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbZACWye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UJLsDz25RKaGtcIcoEl4jLqGef7RzO/uS8ctIAEWcaKYwGSJlVswJzW/R7X7PAsXnE
         MKKnvU/77nvjtCOvgH6F/G/BqeMCLEP9FrA/JI1bGa1/ttZbS5l4nazVFfqqQpms87+k
         W7X3/de9bu+IQzI6pHNdTznQ8Iq83Z1lrVkYI=
Message-ID: <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
Date: Sat, 3 Jan 2009 23:54:30 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Cc: "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <200901020207.30359.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901020207.30359.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Fri, Jan 2, 2009 at 9:07 AM, Rob Landley <rob@landley.net> wrote:
> Before 2.6.25 (specifically git bdc807871d58285737d50dc6163d0feb72cb0dc2 )
> building a Linux kernel never required perl to be installed on the build
> system.  (Various development and debugging scripts were written in perl and
> python and such, but they weren't involved in actually building a kernel.)
> Building a kernel before 2.6.25 could be done with a minimal system built from
> gcc, binutils, bash, make, busybox, uClibc, and the Linux kernel, and nothing
> else.  (Embedded developers creating clean cross compile environments that
>

I agree with Rob that the amount of required dependencies should be
kept to a minimum.

If we only use 0.5% of a certain language (or: dependent package),
then rather implement
that 0.5% in the existing language.

Dependencies very quickly become dependency hell. If A requires B,
then A also inherits all
(future) requirements of B, etc. etc.

In my daily software development work with Linux and GNU software in
general, 10% of it is spent fighting/removing these extremely "thin"
or false depencies, so that it is usuable in embedded devices.


Regards,
-- 
Leon
