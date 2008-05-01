Return-Path: <linux-kernel-owner+w=401wt.eu-S1759770AbYEADTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770AbYEADTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbYEADT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:19:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685AbYEADT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:19:26 -0400
Date: Wed, 30 Apr 2008 20:19:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] net: fix returning void-valued expression
 warnings
In-Reply-To: <1209594005.24729.127.camel@brick>
Message-ID: <alpine.LFD.1.10.0804302016390.5994@woody.linux-foundation.org>
References: <1209593023.24729.117.camel@brick>  <20080430.150832.107441339.davem@davemloft.net> <1209594005.24729.127.camel@brick>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Harvey Harrison wrote:
> 
> Well, in an X86_32 allyesconfig, this only trips 32 times...so it's not
> exactly common.  I agree that there is nothing _wrong_ with this, I'll
> just add Linus and see if we can just call it codingstyle ;)

I actually had a patch to sparse to _not_ complain about it, because I 
think it's one of the sane C++ extensions. I must have lost the patch and 
not sent it upstream.

So in general, I don't mind the "return void_function()" in a void 
function, I think it makes sense from a type standpoint, and sometimes 
results in cleaner code. That said, I'm also not sure it's worth breaking 
the C standard over, so I don't really mind it being fixed in the kernel 
either (but would certainly also not complain if sparse were to be changed 
to not complain)

			Linus
