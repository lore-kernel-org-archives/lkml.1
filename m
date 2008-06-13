Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYFMR35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYFMR35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 13:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYFMR3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 13:29:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:38351 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYFMR3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 13:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=oswGCZ3a+rzvoedfPB8BZdcPpBMTiR6iT+BLbgoxhjbaplH8tustAxwyYD9gZ4ygT7
         NO6gD9orUGTdN4aUs8bkneNaR+5GuDkZowvjHLgBDCkp814YvQCj0tloPIpSKm525QoJ
         HAEnSoNK0X+4373yWeEKoqMgN7M0rfvKhqxZA=
Message-ID: <9929d2390806131029k299804b9i2a1ce47395b98e4e@mail.gmail.com>
Date: Fri, 13 Jun 2008 10:29:42 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] [UPDATED] ixgbe: add LRO support
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@daveloft.net
In-Reply-To: <20080613093835.4b092360.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613162643.27996.32104.stgit@localhost.localdomain>
	 <20080613093835.4b092360.randy.dunlap@oracle.com>
X-Google-Sender-Auth: 5c8128ad33531938
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 9:38 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> +       depends on PCI && INET
>
>> +     select INET_LRO
>
> If INET is not enabled, selecting INET_LRO still won't enable INET and
> build errors will result.  See the other drivers that select INET_LRO...
>
>

Thanks for the catch Randy.  I have updated the patch and will send it out.

-- 
Cheers,
Jeff
