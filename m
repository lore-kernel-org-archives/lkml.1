Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbYF3RGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbYF3RGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYF3RGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:06:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYF3RG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:06:29 -0400
Date: Mon, 30 Jun 2008 12:01:58 -0500
From: David Teigland <teigland@redhat.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dlm: fix uninitialized variable for search_rsb_list callers
Message-ID: <20080630170157.GB31662@redhat.com>
References: <1214845154-4978-1-git-send-email-bhalevy@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214845154-4978-1-git-send-email-bhalevy@panasas.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 07:59:14PM +0300, Benny Halevy wrote:
> gcc 4.3.0 correctly emits the following warning.
> search_rsb_list does not *r_ret if no dlm_rsb is found
> and _search_rsb may pass the uninitialized value upstream
> on the error path when both calls to search_rsb_list
> return non-zero error.
> 
> The fix sets *r_ret to NULL on search_rsb_list's not-found path.

Added to dlm.git.
Thanks, Dave

