Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbXKULOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbXKULOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbXKULOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:14:39 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:30888 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbXKULOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:14:38 -0500
Message-ID: <4744131B.1020908@fr.ibm.com>
Date: Wed, 21 Nov 2007 12:14:35 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] Isolate the UTS namespace's domainname and hostname back
References: <4744113B.5010309@openvz.org>
In-Reply-To: <4744113B.5010309@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> The commit
> 
> commit 7d69a1f4a72b18876c99c697692b78339d491568
> Author: Cedric Le Goater <clg@fr.ibm.com>
> Date:   Sun Jul 15 23:40:58 2007 -0700
> 
>     remove CONFIG_UTS_NS and CONFIG_IPC_NS
> 
> accidentally removed the code, that prevented the uts->hostname
> and uts->domainname values from being overwritten from another
> namespace. In other words, setting hostname/domainname via sysfs 
> (echo xxx > /proc/sys/kernel/(host|domain)name) cased the new
> value to be set in init UTS namespace only.
> 
> Return the isolation back.

yep. sorry about that. I was going to send the same patch in a 
minute. 

> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: Cedric Le Goater <clg@fr.ibm.com>

Thanks,

C.
