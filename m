Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752990AbYLQV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbYLQV5A (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYLQV4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:56:51 -0500
Received: from are.twiddle.net ([75.149.56.221]:55566 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYLQV4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:56:50 -0500
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2008 16:56:50 EST
Message-ID: <4949732A.4050207@twiddle.net>
Date: Wed, 17 Dec 2008 13:46:18 -0800
From: Richard Henderson <rth@twiddle.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: questions about native alpha futex implementation
References: <b4198de60812171113r72d8d04ao67cde38c62185bcc@mail.gmail.com>
In-Reply-To: <b4198de60812171113r72d8d04ao67cde38c62185bcc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Turner wrote:
> Hi,
> 
> Alpha uses a generic futex implementation, which causes some problems [1].
> 
> I've read through the code, and it appears as if the implementation
> could be done by using the ldq_l/stq_c instructions, relatively easy I
> might add. I'm definitely interested in implementing this, but first...
> 
> I have only a few questions.
> 
> 1) What are the benefits of a native futex implementation, other than
> fixing the glibc test failures?
> 2) Is there a technical reason it hasn't been implemented on Alpha?
> 3) Am in correct that it could be done with ldq_l/stq_c instructions?

I think all the futex stuff is 32-bits wide, so ldl_l/stl_c.
You can pretty much just copy the powerpc version, as that
platform also uses load-locked/store-conditional operations.


r~
