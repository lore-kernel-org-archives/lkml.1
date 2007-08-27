Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbXH0Otl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbXH0Otl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 10:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXH0Ote
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 10:49:34 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:45827 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861AbXH0Otc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 10:49:32 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Kentaro Takeda <k.takeda26@gmail.com>
Subject: Re: [TOMOYO 15/15] LSM expansion for TOMOYO Linux.
Date: Mon, 27 Aug 2007 10:49:06 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
References: <46CED214.6050505@gmail.com> <46CED5F4.3030204@gmail.com>
In-Reply-To: <46CED5F4.3030204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708271049.06900.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 24 2007 8:58:28 am Kentaro Takeda wrote:
> LSM hooks for network accept and recv:
>    * socket_post_accept is modified to return int.

This has been discussed several times on various lists and is not considered 
an acceptable solution to blocking incoming stream connection attempts.  
Please take a look at the existing LSM stream connection request hooks as 
well as how SELinux makes use of them.

>    * post_recv_datagram is added in skb_recv_datagram.

Can you explain to me why this is not possible using the existing 
security_socket_sock_rcv_skb() LSM hook?

-- 
paul moore
linux security @ hp
