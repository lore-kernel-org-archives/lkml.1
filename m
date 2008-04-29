Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbYD2U2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbYD2U2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761032AbYD2U2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:28:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:58291 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762869AbYD2U2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kOTT4hBro38f4jDd5K3l9YpLDaHxshUSinnUJZTQqJUdBjNHjvS/3S9MmvR7aQV52B94N7dNbmlzsvInM8wdx5tg6qGC/t/Xb4U032hCrw+zDBk5nTxsoyx4nLLVHMqiZWumdPU7qUS/NLhDqwlZocH0+KVmP2FZSaeiSZHz/LQ=
Message-ID: <12c511ca0804291328v2f0b87csd0f2cf3accc6ad00@mail.gmail.com>
Date: Tue, 29 Apr 2008 13:28:14 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: Nadia.Derbey@bull.net
Subject: Re: [PATCH 1/8] Scaling msgmni to the amount of lowmem
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, matthltc@us.ibm.com,
       cmm@us.ibm.com
In-Reply-To: <20080211141813.354484000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080211141646.948191000@bull.net>
	 <20080211141813.354484000@bull.net>
X-Google-Sender-Auth: a9485e02cd1affc6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 7:16 AM,  <Nadia.Derbey@bull.net> wrote:
>  Index: linux-2.6.24-mm1/ipc/msg.c
>  ===================================================================
>  --- linux-2.6.24-mm1.orig/ipc/msg.c     2008-02-07 15:02:29.000000000 +0100
>  +++ linux-2.6.24-mm1/ipc/msg.c  2008-02-07 15:24:19.000000000 +0100
...
>  +out_callback:
>  +
>  +       printk(KERN_INFO "msgmni has been set to %d for ipc namespace %p\n",
>  +               ns->msg_ctlmni, ns);
>  +}

This patch has now made its way to mainline.  I can see how this printk
was really useful to you while developing this patch. But does it add
much value in a production system? It just looks like another piece of
clutter on the console to my uncontainerized eyes.

-Tony
