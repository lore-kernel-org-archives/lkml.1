Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbZFJTHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbZFJTHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZFJTHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:07:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:35226 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZFJTH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:07:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wAYykUjPaVlEJDh7gNUpykXyeBwlTVcaHNWUTEUFfP07uFzIdJBafd5tv4NE6QJjaa
         xpOge8NgZaSYzwOqgU53f/LUEuuFDGYrDrHV9jhz95p5uyKregZyqFb7OBXCTxbz0YKK
         A495uT/ltOT69vRMVCWajNCb/HUun8KBL/018=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906101441410.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org> 
	<1244623722-6325-2-git-send-email-vapier@gentoo.org> <alpine.DEB.2.00.0906101303560.30552@gandalf.stny.rr.com> 
	<8bd0f97a0906101131m2fc21f75uc174631150897e5e@mail.gmail.com> 
	<alpine.DEB.2.00.0906101441410.30552@gandalf.stny.rr.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 10 Jun 2009 15:07:11 -0400
Message-ID: <8bd0f97a0906101207s3eb36ccbp7baa631a941b9b0f@mail.gmail.com>
Subject: Re: [PATCH 2/2] ftrace: document basic ftracer/ftracer graph needs
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 14:45, Steven Rostedt wrote:
> On Wed, 10 Jun 2009, Mike Frysinger wrote:
>> there should be at least tips in each HAVE_XXX as to where to look for
>> implementation details.
>
> That can be opening a can of worms.

no it isnt:
config HAVE_FUNCTION_TRACER
    bool
    help
      Please see Documentation/trace/ftrace-implementation.txt

> Really, the focus of the documentation in Kconfig is about why things must
> be selected, not how to implement the code to add that selection.

except that some of these defines come from the exact implementation details.

> If there's a HAVE_XXX in Kconfig that I want to see how to implement it, I
> go off and do 'grep -r XXX Documentation'.

i look for the source of the define because ive given up on the
Documentation actually being relevant
-mike
