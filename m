Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbZBMVRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbZBMVRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZBMVRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:17:43 -0500
Received: from gw.goop.org ([64.81.55.164]:34951 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZBMVRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:17:42 -0500
Message-ID: <4995E373.9030309@goop.org>
Date: Fri, 13 Feb 2009 13:17:39 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <49939964.4070607@kernel.org> <49939B08.1050801@kernel.org> <200902140728.55954.rusty@rustcorp.com.au>
In-Reply-To: <200902140728.55954.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> That's why I handed it to you! :)
>
> Just remember we waited over 5 years for this to happen: the point of these
> is that Christoph showed it's still useful.
>
> (And I really like the idea of allocing congruent areas rather than remapping
>  if someone can show that it's semi-reliable.  Good luck!)

I really don't like the idea of making percpu memory (physically) move 
around.  It would break Xen's usage of it for a start...  Virtual 
remapping would be OK.

    J
