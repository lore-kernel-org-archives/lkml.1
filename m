Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0CHPQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:16:25 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:43327 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0CHPQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:16:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ht1DXhVbtNztMQfVFH1nYR6fH0ASTtH4sdK6OMck82DeyUw4ee6Rx324/eUFIT2RCq
         ZtVgH++bHYrpkVIqcDkY4ViDqFEj/wQMRhdgqtYaTiFEZgQDqfqzZewdl0pbdRntvy59
         54xYffPyd+uR1g78vtMgFa7W7fGPRtSnM2a1E=
Date: Mon, 8 Mar 2010 17:16:15 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, eparis@redhat.com,
       faith@redhat.com
Subject: Re: [PATCH] Kernel: Fix coding style in kernel/audit.c
Message-ID: <20100308151614.GA4081@x200>
References: <20100308222742.GB17489@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308222742.GB17489@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 06:27:42AM +0800, wzt.wzt@gmail.com wrote:
> @@ -346,8 +346,8 @@ static int audit_set_enabled(int state, uid_t loginuid, u32 sessionid, u32 sid)
>  static int audit_set_failure(int state, uid_t loginuid, u32 sessionid, u32 sid)
>  {
>  	if (state != AUDIT_FAIL_SILENT
> -	    && state != AUDIT_FAIL_PRINTK
> -	    && state != AUDIT_FAIL_PANIC)
> +		&& state != AUDIT_FAIL_PRINTK
> +		&& state != AUDIT_FAIL_PANIC)

Come on.
