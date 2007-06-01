Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXFAU44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXFAU44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbXFAU4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:56:43 -0400
Received: from gw.goop.org ([64.81.55.164]:56066 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267AbXFAU4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:56:42 -0400
Message-ID: <46608803.2090707@goop.org>
Date: Fri, 01 Jun 2007 13:56:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com> <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 1 Jun 2007, Jeremy Fitzhardinge wrote:
>
>   
>> I think this is a good example of why having to special-case kmalloc(0)
>> is a bad idea.  The original code was straightforward and, barring
>> silliness, should be completely correct with npids==0.  This new code
>> does nothing other than make things more complex.
>>     
>
> Hehe we got you. 

Bugger ;) Well, my get-out clause was "barring silliness".

J
