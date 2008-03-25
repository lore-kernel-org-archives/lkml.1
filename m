Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYCYLCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYCYLCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 07:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYCYLCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 07:02:31 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:46237 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbYCYLCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 07:02:30 -0400
Message-ID: <47E8DBBE.4030607@mev.co.uk>
Date: Tue, 25 Mar 2008 11:02:22 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080317)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Corrections to Documentation/rbtree.txt
References: <47E282F5.6090703@mev.co.uk> <200803201339.18618.rob@landley.net>
In-Reply-To: <200803201339.18618.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2008 11:02:23.0303 (UTC) FILETIME=[B4048570:01C88E67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/08 18:39, Rob Landley wrote:
> On Thursday 20 March 2008 10:29:57 Ian Abbott wrote:
>> From: Ian Abbott <abbotti@mev.co.uk>
>>
>> The description of the rb_entry() macro in Documentation/rbtree.txt seems
>> incorrect. This patch improves it (hopefully).  Also I changed the example
>> code to call the previous 'my_search()' example instead of an undefined
>> 'mysearch()'.
> 
> I have no objection to the patch (and the my_search thing seems like an 
> obvious typo), but is there a reason to prefer rb_entry() rather than 
> container_of()?  If so, the rationale might be a good thing to add to the 
> documentation...

I don't know the rationale, but all the code I can see uses rb_entry() 
and not container_of().  The only rationale I can think of is that it 
abstracts away from the nodes being embedded in the data a little bit. 
(But not by much - in particular, an implementation of rb trees that 
stored data in the node explicitly would only need a single parameter in 
its rb_entry() accessor.  I like the approach taken in 
include/linux/elevator.h that uses the rb_entry() macro to create a 
specialized accessor macro (rb_entry_rq()) with a single parameter.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
