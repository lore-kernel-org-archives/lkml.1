Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZHRWKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZHRWKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZHRWKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:10:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41101 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZHRWKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:10:41 -0400
Subject: Re: [PATCH 2/3]HTLB mapping for drivers. Hstate for files with
 hugetlb mapping(take 2)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Korolev <akorolev@infradead.org>
Cc: mel@csn.ul.ie, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0908172333410.32114@casper.infradead.org>
References: <alpine.LFD.2.00.0908172333410.32114@casper.infradead.org>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 15:10:38 -0700
Message-Id: <1250633438.7335.1146.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 23:40 +0100, Alexey Korolev wrote:
> 
> @@ -110,6 +111,10 @@ static inline void hugetlb_report_meminfo(struct
> seq_file *m)
>  #endif /* !CONFIG_HUGETLB_PAGE */
> 
>  #ifdef CONFIG_HUGETLBFS
> +
> +/* some random number */
> +#define HUGETLBFS_MAGIC        0x958458f6

Doesn't this belong in include/linux/magic.h?

-- Dave

