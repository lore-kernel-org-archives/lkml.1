Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYHHM6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYHHM6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYHHM6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:58:05 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:33597 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYHHM6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:58:04 -0400
Subject: Re: [PATCH 1/1] allocate structures for reservation tracking in
	hugetlbfs outside of spinlocks v2
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <1218193855-25832-1-git-send-email-apw@shadowen.org>
References: <20080807143824.8e0803da.akpm@linux-foundation.org>
	 <1218193855-25832-1-git-send-email-apw@shadowen.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:57:55 +0200
Message-Id: <1218200276.10315.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 12:10 +0100, Andy Whitcroft wrote:
> [Bah, while reviewing the locking based on your previous email I spotted
> that we need to check the return from the vma_needs_reservation call for
> allocation errors.  Here is an updated patch to correct this.  This passes
> testing here.  Gerald could you test thing one too.]

Ok, it works here too.

Thanks,
Gerald


