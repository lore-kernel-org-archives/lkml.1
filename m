Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZFTC3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZFTC3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 22:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZFTC24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 22:28:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZFTC2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 22:28:55 -0400
Message-ID: <4A3C4946.6030100@redhat.com>
Date: Fri, 19 Jun 2009 22:28:22 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/4] tmem: precache implementation (layered on tmem)
References: <67c05b05-c8e2-4e8f-a234-52a86e657404@default>
In-Reply-To: <67c05b05-c8e2-4e8f-a234-52a86e657404@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:

> @@ -110,6 +111,9 @@
>  		s->s_qcop = sb_quotactl_ops;
>  		s->s_op = &default_op;
>  		s->s_time_gran = 1000000000;
> +#ifdef CONFIG_PRECACHE
> +		s->precache_poolid = -1;
> +#endif
>  	}
>  out:
>  	return s;

Please generate your patches with -up so we can see
which functions are being modified by each patch hunk.
That makes it a lot easier to find the context and
see what you are trying to do.

-- 
All rights reversed.
