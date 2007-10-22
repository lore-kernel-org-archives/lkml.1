Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbXJVC67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbXJVC67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXJVC6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:58:53 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:33111 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbXJVC6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:58:52 -0400
Message-ID: <471C11E5.2000003@tiscali.nl>
Date: Mon, 22 Oct 2007 04:58:45 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unlock before bug returns
References: <471C0697.1040906@tiscali.nl>
In-Reply-To: <471C0697.1040906@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:

>     unlock before bug returns

>  	if (cs >= GPMC_CS_NUM || !gpmc_cs_reserved(cs)) {
>  		printk(KERN_ERR "Trying to free non-reserved GPMC CS%d\n", cs);
> -		BUG();
>  		spin_unlock(&gpmc_mem_lock);
> -		return;
> +		BUG();


should we bother to unlock before panicking, or is the unlock not required either?

