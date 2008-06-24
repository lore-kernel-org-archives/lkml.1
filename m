Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYFXB7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYFXB7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYFXB7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:59:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53646 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYFXB67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:58:59 -0400
Message-ID: <4860547F.5000002@cn.fujitsu.com>
Date: Tue, 24 Jun 2008 09:57:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, johnpol@2ka.mipt.ru
Subject: Re: [PATCH] CONNECTOR: add a proc entry to list connectors
References: <48604E44.5040402@cn.fujitsu.com> <20080623.184557.72075822.davem@davemloft.net>
In-Reply-To: <20080623.184557.72075822.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Tue, 24 Jun 2008 09:30:44 +0800
> 
>> I got a problem when I wanted to check if the kernel supports process
>> event connector, and It seems there's no way to do this check.
> 
> Try to create a connector socket.
>  

Do you mean socket(PF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR); ?

But this has nothing to do with process event connector. If it's not
supported, both socket() and bind() return successfully, just I can
recv() nothing.
