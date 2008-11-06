Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbYKFVUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbYKFVUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYKFVUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:20:08 -0500
Received: from gw.goop.org ([64.81.55.164]:34523 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbYKFVUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:20:07 -0500
Message-ID: <49135F84.2060302@goop.org>
Date: Thu, 06 Nov 2008 13:20:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
       "Christopher S. Aker" <caker@theshore.net>,
       xen devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] 2.6.27 - SMP enabled, but only 1 CPU
References: <48F3BC99.5040409@theshore.net> <490F5F50.7020704@theshore.net> <4910AD00.7040605@theshore.net> <4911BC52.7040905@theshore.net> <1225994697.12607.837.camel@zakaz.uk.xensource.com> <49134257.4000404@goop.org> <20081106211639.GA24579@elte.hu>
In-Reply-To: <20081106211639.GA24579@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> a "cleanup" impact line is only added if the change is not intended to 
> have any side-effects whatsoever.
>
> We can drop it but it would be really nice to figure out what's going 
> on. In a very quick late-night look i cannot see anything particularly 
> weird about it, but based on the type of changes it does there are 
> three leading candidates: lost high 32 bits, zero extend problem, or 
> incorrect types.

Yeah, I couldn't see anything either.  It's a reasonable cleanup (I 
never did understand that struct page * cast), but its always nicer when 
cleanups don't break working code ;).

    J
