Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbZCZXvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbZCZXvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZCZXvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:51:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:38828 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZCZXvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aPyFqZG8bKNU8Pe52A6OhL3N8DdHP/kWMliHH5iNzLKWkfPwp2r8BAcsIrl1FquSU6
         h2FBCO4AYylvdAwauuXV75dthcu6Lk7bqUR0TNXMuv80s25yFZFuiR+kRb1TlgvyKf3e
         nSDvJ+lptkpbksCInNT0h9B6ksWYwskSLA5tg=
Date: Fri, 27 Mar 2009 02:58:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mark <mbeauch@cox.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: compressed elf core dumps
Message-ID: <20090326235829.GA5712@x200.localdomain>
References: <49CC032C.20001@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC032C.20001@cox.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 06:35:24PM -0400, Mark wrote:
> I have a patch set based of a slightly older kernel which offers compressed(gzip)
> core dumps. These files compress exceptionally well.  This feature can be 
> helpful for embedded linux systems with smaller file systems.  The core 
> dumps can be taken off line, un-compressed and analyzed.  
>
> If there's any interest, I'll update the patch and post it.

Do this by feeding coredump to external process via
/proc/sys/kernel/core_pattern
