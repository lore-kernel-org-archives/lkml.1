Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbYG1NqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbYG1NqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYG1Npz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:45:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35054 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYG1Npy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:45:54 -0400
Message-ID: <488DCD70.4020003@zytor.com>
Date: Mon, 28 Jul 2008 09:45:20 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] i386: improve double fault handling
References: <4880A912.76E4.0078.0@novell.com> <4881263B.7060700@zytor.com> <48846B02.76E4.0078.0@novell.com> <20080721110510.GC10782@elte.hu> <4885CEFE.76E4.0078.0@novell.com> <20080728134252.GI5515@elte.hu>
In-Reply-To: <20080728134252.GI5515@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Secondly, task gates are really a relic that should not be proliferated. 
> Besides the complications in virtualized environments (if more common 
> things like Big Real Mode are not supported well in virtual mode what do 
> we expect of more esoteric features as task gates?) it does not get 
> nearly as much testing on real silicon as other, more mainstream CPU 
> features.
> 

I think that using it as a bailout mechanism is going to remain 
supported and tested.  It's just never going to be fast.

	-hpa

