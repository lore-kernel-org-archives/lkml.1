Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYGYQnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYGYQnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYGYQnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:43:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42265 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYGYQnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:43:14 -0400
Date: Fri, 25 Jul 2008 09:42:54 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Denis ChengRq <crquan@gmail.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/scsi/aic94xx/: replace __FUNCTION__ with
	__func__
Message-ID: <20080725164253.GA7355@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <1216954114-31949-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216954114-31949-1-git-send-email-crquan@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 10:48:33AM +0800, Denis ChengRq wrote:
> Signed-off-by: Denis ChengRq <crquan@gmail.com>

No justification or changelog?

> -		__FUNCTION__)
> +		__func__)

include/linux/kernel.h:503:#define __FUNCTION__ (__func__)

I assume you're trying to kill this?

--D
