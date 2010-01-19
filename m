Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0AST7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0AST7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039Ab0AST7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:59:42 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49289 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0AST7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:59:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C1x+Q7n2nKJKJ5LfZ6eA+CEMabzIMlFj/D4Y4fUHNMUPb4tXlaDgrmsH6giDebjGyN
         nDXiOrdfZq6EyuFSNYCxqvuSXgUBrQnw+a04tqiYhBiEdbc9JpN+YCyUkgmT1XG5RyRu
         u1DSsvygrG7KtDxATBP1IEsS/A1OVxOX4sulM=
Date: Tue, 19 Jan 2010 20:59:33 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100119195933.GA3060@del.dom.local>
References: <20100118204658.GC3157@del.dom.local>
 <4B54CB0D.5070604@majjas.com>
 <20100118212516.GE3157@del.dom.local>
 <4B54D50C.90608@majjas.com>
 <20100118220814.GG3157@del.dom.local>
 <20100118221747.GH3157@del.dom.local>
 <4B54E4EF.8080602@majjas.com>
 <4B554730.6090000@majjas.com>
 <20100119104739.GA9088@ff.dom.local>
 <4B55D40F.5080509@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B55D40F.5080509@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 10:47:27AM -0500, Michael Breuer wrote:
...
> Still get the warning... but now 60 bytes.
> Jan 19 10:43:50 mail kernel: ------------[ cut here ]------------
> Jan 19 10:43:50 mail kernel: WARNING: at lib/dma-debug.c:902

Thanks for trying this.
Jarek P.
