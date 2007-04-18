Return-Path: <linux-kernel-owner+w=401wt.eu-S2992680AbXDROps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992680AbXDROps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992685AbXDROpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:45:47 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34081 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992680AbXDROpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:45:46 -0400
Date: Wed, 18 Apr 2007 07:40:27 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: mpm@selenic.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take4 2/6] support multiple logging
Message-ID: <20070418074027.48375647@localhost.localdomain>
In-Reply-To: <462609D1.50300@bx.jp.nec.com>
References: <462605DC.2080804@bx.jp.nec.com>
	<462609D1.50300@bx.jp.nec.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 21:06:41 +0900
Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:

> From: Keiichi KII <k-keiichi@bx.jp.nec.com>
> 
> This patch contains the following changes for supporting multiple logging
>  agents.
> 
> 1. extend netconsole to multiple netpolls
>    To send kernel messages to multiple logging agents, extend netcosnole
>     to be able to use multiple netpolls. Each netpoll sends kernel messages
>     to its own logging agent.
> 
> 2. change config parameter format
>    We change config parameter format from single configuration to multiple 
>    configurations separated by ';'.
> 
>    ex) sending kernel messages to destination1 and destination2 using eth0.
>     modprobe netconsole \
>             netconsole="@/eth0,@[destination1]/;@/eth0,@[destination2]/"

Please include an update to Documentation/networking/netconsole.txt
