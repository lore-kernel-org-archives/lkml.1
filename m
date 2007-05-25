Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbXEYFW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbXEYFW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbXEYFWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:22:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:33768 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbXEYFWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:22:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GL94jQW3VsBVVAiMLFe0Kq+QCQjbBEKi7T1DhIFlPeZUtjwWbDugI5uazcNXSW8IfMpmAiwdByVAPOB6/X3lk0pKMkLXhrcLktHLmZsE/zwFixUsMi3YxTLefi+N/N0CerJZt40ih0eiHfK5Q1YpvDv73oe3cvnu3ZKQ4H+7Kgw=
Message-ID: <a8e1da0705242222n2414a66bo97d20c82c6a497e4@mail.gmail.com>
Date: Fri, 25 May 2007 05:22:50 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: 2.6.22-rc2-mm1 NTFS & SLUB related fix
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705242202340.1327@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
	 <Pine.LNX.4.64.0705242202340.1327@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Is this ntfs_init_locked_inode?

Yes, it is.

> >  Bytes b4 0xc2959e28:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a
> >    Object 0xc2959e38:  24 00 51 00 00 00 6b a5
> >   Redzone 0xc2959e40:  00 00 cc cc
>
> First two bytes after the object overwritten. The allocation for this
> object should have been two bytes longer.
>
> > Last alloc: ntfs_init_locked_inode+0x9e/0x110 jiffies_ago=5140 cpu=0 pid=1604
>
> This is the function that allocated a too short object.
>

Only the last one byte of  the string  is zeroed, but It malloced 2
more byte appended the string because size of thentfschar type is 2
bytes , is this the reason? But why?

Regards
dave
