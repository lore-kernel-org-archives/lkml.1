Return-Path: <linux-kernel-owner+w=401wt.eu-S932654AbXBSUrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbXBSUrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932652AbXBSUrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:47:15 -0500
Received: from kanga.kvack.org ([66.96.29.28]:60852 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648AbXBSUrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:47:15 -0500
Date: Mon, 19 Feb 2007 15:47:03 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Leonid Ananiev <leonid.i.ananiev@intel.com>
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion event
Message-ID: <20070219204703.GB31205@kvack.org>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 12:35:27PM -0800, Zach Brown wrote:
> aio: propogate post-EIOCBQUEUED errors to completion event

This patch has to be split in 2 to make it easier to review -- the change 
moving the event insertion code for the completion queue should stand 
separately, as it is completely unrelated to the rest of the patch.  I 
*think* the patch is right, but picking the changes to the code and watching 
its movement at the same time is making my head spin.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.
