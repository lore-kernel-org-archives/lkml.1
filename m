Return-Path: <linux-kernel-owner+w=401wt.eu-S1751759Ab0AaGxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab0AaGxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 01:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484Ab0AaGxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 01:53:41 -0500
Received: from mail-qy0-f182.google.com ([209.85.221.182]:51078 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0AaGxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 01:53:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f+NdezY/qrRyeUcdgfPNjxSuMhcEhp+JPVzFimEdlAWxiYix658vUY1gqjfr3Yf2aa
         cqryrriAgxgXLsakwkyK5HEXguauA+z4mY5920JmKsbXF6c/mTLXMRfcBcoVx95ioEFH
         Nfous6+KJEPGALspDHpdAmnV7JV+sVMjMeR6M=
MIME-Version: 1.0
In-Reply-To: <20100131061221.GK2996@kryten>
References: <20100131061221.GK2996@kryten>
Date: Sun, 31 Jan 2010 15:53:39 +0900
Message-ID: <961aa3351001302253sfd629cfsd00cf9a338c0b78@mail.gmail.com>
Subject: Re: [PATCH] fault injection: Correct function names in documentation
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/31 Anton Blanchard <anton@samba.org>:
>
> init_fault_attr_entries should be init_fault_attr_dentries
> cleanup_fault_attr_entries should be cleanup_fault_attr_dentries
>
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>
> Index: linux-cpumask/Documentation/fault-injection/fault-injection.txt
> ===================================================================
> --- linux-cpumask.orig/Documentation/fault-injection/fault-injection.txt        2010-01-30 17:20:54.147210801 +1100
> +++ linux-cpumask/Documentation/fault-injection/fault-injection.txt     2010-01-31 17:11:10.737211232 +1100
> @@ -143,8 +143,8 @@ o provide a way to configure fault attri
>   failslab, fail_page_alloc, and fail_make_request use this way.
>   Helper functions:
>
> -       init_fault_attr_entries(entries, attr, name);
> -       void cleanup_fault_attr_entries(entries);
> +       init_fault_attr_dentries(entries, attr, name);
> +       void cleanup_fault_attr_dentries(entries);
>
>  - module parameters
>
>

Looks good.

Thanks.
