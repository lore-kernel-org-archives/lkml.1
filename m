Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYHGNuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYHGNuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYHGNuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:50:08 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:56237 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYHGNuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:50:06 -0400
Subject: Re: [PATCH] drivers/s390: Use an IS_ERR test rather than a NULL
	test
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Julien Brunel <brunel@diku.dk>
Cc: heiko.carstens@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <200808071542.22880.brunel@diku.dk>
References: <200808071542.22880.brunel@diku.dk>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 07 Aug 2008 15:49:12 +0200
Message-Id: <1218116952.1033.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 15:42 +0200, Julien Brunel wrote:
> In case of error, functions dasd_kmalloc_request and idal_buffer_alloc
> return an ERR pointer, but never return the NULL pointer. So after a
> call to one of these functions, a NULL test should be replaced by an
> IS_ERR test.

Good findings, many thanks! I'll add it to git390 for the next please
pull.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


