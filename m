Return-Path: <linux-kernel-owner+w=401wt.eu-S932384Ab0AFRLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab0AFRLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254Ab0AFRLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:11:15 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:56383 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab0AFRLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:11:14 -0500
Subject: Re: [PATCH 2/7] Export unusable free space index via
 /proc/pagetypeinfo
From: Adam Litke <agl@us.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1262795169-9095-3-git-send-email-mel@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
	 <1262795169-9095-3-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 06 Jan 2010 11:10:48 -0600
Message-ID: <1262797848.3579.8.camel@aglitke>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 16:26 +0000, Mel Gorman wrote:
> +/*
> + * Return an index indicating how much of the available free memory is
> + * unusable for an allocation of the requested size.
> + */
> +int unusable_free_index(struct zone *zone,
> +				unsigned int order,
> +				struct config_page_info *info)
> +{
> +	/* No free memory is interpreted as all free memory is unusable */
> +	if (info->free_pages == 0)
> +		return 100;

Should the above be 1000?


-- 
Thanks,
Adam

