Return-Path: <linux-kernel-owner+w=401wt.eu-S1759005AbZBZVuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbZBZVuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZBZVuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:50:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbZBZVuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:50:01 -0500
Date: Thu, 26 Feb 2009 13:49:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49A70B24.6090706@krogh.cc>
Message-ID: <alpine.LFD.2.00.0902261344440.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc> <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
 <49A70B24.6090706@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Jesper Krogh wrote:
> 
> > Also mind sending the full dmesg for both kernels?
> 
> http://krogh.cc/~jesper/dmesg-2.6.29-rc6.txt
> http://krogh.cc/~jesper/dmesg-2.6.26.8.txt

Try changing

	#define QUICK_PIT_MS 15

in arch/x86/kernel/tsc.c into something bigger. Let's say just doubling 
it to 30. Does that change anything?

		Linus

