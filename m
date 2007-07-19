Return-Path: <linux-kernel-owner+w=401wt.eu-S1765883AbXGSVJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765883AbXGSVJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbXGSVJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:09:42 -0400
Received: from gw.goop.org ([64.81.55.164]:56784 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760729AbXGSVJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:09:42 -0400
Message-ID: <469FD2D7.1010808@goop.org>
Date: Thu, 19 Jul 2007 14:08:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, Zachary Amsden <zach@vmware.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patches] new text patching for review
References: <200707191105.44056.ak@suse.de> <200707192246.58047.ak@suse.de> <469FCEE7.8060900@goop.org> <200707192306.20625.ak@suse.de>
In-Reply-To: <200707192306.20625.ak@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Either not use any pvops or make sure all the pvops patching is atomic
> on the local CPU.
>   

Erk, not really keen on that.  Sounds complicated, unless there's a nice
general algorithm.

> Ok you can avoid MCEs by not enabling them until after you patch (which I think
> is the case currently), but it's more difficult with NMIs.
>
> The plain NMI handler is probably auditable.
> Or set a flag that makes the NMI handler just return during patching?
>   

I think that's probably the simplest, if nobody will miss it.

    J
