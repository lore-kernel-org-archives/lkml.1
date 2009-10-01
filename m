Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZJAWxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZJAWxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZJAWxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:53:16 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50222 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbZJAWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mqyTABd/I6t37dc786u2n6BYCY5j9LMdpqRz9wktn3aiFp5RdQEAxHZCMbqz1wKUtR
         r6XWDYQT5P+qqJeIYBfO9UTM9KpCRrw+4ihWsbzs0OmwZMkGrUfKxTcaE35IEjL6cUD+
         lVgvzgNHhSEYo/xZcBlZ1wfygUk0wQpgj0Hy4=
Message-ID: <4AC532DB.1050205@gmail.com>
Date: Fri, 02 Oct 2009 00:53:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] isicom.c: Use pr_fmt and pr_<level>
References: <1254428738.1799.95.camel@Joe-Laptop.home>
In-Reply-To: <1254428738.1799.95.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 10:25 PM, Joe Perches wrote:
> Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Converted some embedded function names to %s...__func__
> Removed a period after exclamation points.
> Removed #define pr_dbg which could be used by future kernel.h includes
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Jiri Slaby <jirislaby@gmail.com>
