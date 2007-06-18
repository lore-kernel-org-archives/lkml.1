Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbXFRUDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbXFRUDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761800AbXFRUDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:03:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:32267 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761487AbXFRUDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IMJb1ic/r9SeJA4Dk34u3nsN79W1FK9LbO5AokiGrLuR+hyL5Qrapjq/iemmjL+gtXMeECb7zludZ+13YbwFvcJ4+98nwTRSKU84GhtS/8cRwPN9RgPycKoQl9KX0A+K0C4QJsWQZGykcslC/wkU2rWzSj+Vz2xZxmQH15ojbCY=
Message-ID: <84144f020706181303q194cba73q1fa158718218e1e9@mail.gmail.com>
Date: Mon, 18 Jun 2007 23:03:08 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [patch 02/26] Slab allocators: Consolidate code for krealloc in mm/util.c
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
In-Reply-To: <20070618095913.872115919@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <20070618095913.872115919@sgi.com>
X-Google-Sender-Auth: 92337e051aa9b6c7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> The size of a kmalloc object is readily available via ksize().
> ksize is provided by all allocators and thus we canb implement
> krealloc in a generic way.
>
> Implement krealloc in mm/util.c and drop slab specific implementations
> of krealloc.

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
