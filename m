Return-Path: <linux-kernel-owner+w=401wt.eu-S935076AbYBUVtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076AbYBUVtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYBUVtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:49:13 -0500
Received: from gw.goop.org ([64.81.55.164]:57705 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbYBUVtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:49:12 -0500
Message-ID: <47BDF151.30809@goop.org>
Date: Thu, 21 Feb 2008 13:46:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Implement getgeo for Xen virtual block device.
References: <47BDE731.60801@goop.org> <alpine.LFD.1.00.0802211315190.19896@woody.linux-foundation.org> <47BDEA5E.4070800@goop.org> <alpine.LFD.1.00.0802211337220.19896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802211337220.19896@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 21 Feb 2008, Jeremy Fitzhardinge wrote:
>   
>> OK.  Have you fixed it, or shall I resend?
>>     
>
> I'll fix it, but I want people to know so that I don't have to fix things 
> like this in the future (*).
>
> 			Linus
>
> (*) I keed, I keed. Of *course* I'll have to fix things like this in the 
> future too. But hopefully not quite as often.
>   

Putting the From: in the Signed-off-by block is a result of two thoughts:

   1. putting it at the top makes the most sense from an email
      perspective, but it often seem to get lost by various
      patch-posting programs if it gets tangled in the Subject/summary
      part of the patch.  The result is that it needs to float in an odd
      way:

          Subject: wooble the foo

          From: Foo Woobler <foo@wooble.com>

          Wooble foos in the appropriate manner.

          Signed-off-by: Foo Woobler <foo@wooble.com>
          Cc: Bar Mangler <bar@mangle.org> 
          

   2. There's already a block of email addresses which describe how
      people relate to this patch, so why not put From: there (since it
      isn't really an email From header, but a patch metadata header). 
      I'd assumed that tools which pick "Thing: Email" pairs out of a
      patch would deal with From in the same place as a Signed-off-by. 
      After all, tools deal with Cc:s there.


I'll make sure From: is in the right place in future, but I just wanted 
to point out it wasn't complete randomness.

    J
