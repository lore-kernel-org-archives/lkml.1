Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXDEDHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXDEDHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932469AbXDEDHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:07:00 -0400
Received: from smtpout.mac.com ([17.250.248.171]:58914 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXDEDG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:06:59 -0400
In-Reply-To: <1175742090.12230.630.camel@localhost.localdomain>
References: <1175714071.9371.31.camel@localhost.localdomain> <1175742090.12230.630.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <72C854B9-1A7F-44C5-9D62-B6B63F3A6DE7@mac.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, virtualization@lists.osdl.org,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Lguest32 print hex on bad reads and writes
Date: Wed, 4 Apr 2007 23:06:39 -0400
To: Rusty Russell <rusty@rustcorp.com.au>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 04, 2007, at 23:01:30, Rusty Russell wrote:
> On Wed, 2007-04-04 at 15:14 -0400, Steven Rostedt wrote:
>> Currently the lguest32 error messages from bad reads and writes  
>> prints a decimal integer for addresses. This is pretty annoying.  
>> So this patch changes those to be hex outputs.
>
> (Erk, I wonder what I was thinking when I wrote that?) Can I ask  
> for %#x (or 0x%x)?  I'm easily confused.

How about "%p" for pointers?

Cheers,
Kyle Moffett


