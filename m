Return-Path: <linux-kernel-owner+w=401wt.eu-S966592AbXHaV1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966592AbXHaV1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965674AbXHaV0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:26:53 -0400
Received: from li6-103.members.linode.com ([66.160.141.103]:2555 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966491AbXHaV0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:26:52 -0400
Date: Fri, 31 Aug 2007 14:26:36 -0700
From: Jason Lunz <lunz@falooley.org>
To: jffs-dev@axis.com
Cc: David Woodhouse <dwmw2@infradead.org>, stable@kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: jffs2 deadlock introduced in linux 2.6.22.5
Message-ID: <20070831212636.GB12868@falooley.org>
References: <20070830182354.GA25077@falooley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070830182354.GA25077@falooley.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 11:23:55AM -0700, Jason Lunz wrote:
> commit 1d8715b388c978b0f1b1bf4812fcee0e73b023d7 was added between
> 2.6.22.4 and 2.6.22.5 to cure a locking problem, but it seems to have
> introduced another (worse?) one.

I spoke too soon. I checked more carefully, and this problem was
introduced somewhere between 2.6.21 and 2.6.22. The jffs2 fix in
2.6.22.5 isn't the culprit.

Jason
