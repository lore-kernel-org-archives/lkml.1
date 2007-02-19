Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbXBSSnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbXBSSnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932486AbXBSSnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:43:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43131 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbXBSSnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:43:05 -0500
Subject: Re: [PATCH 0/7] [RFC] hugetlb: pagetable_operations API
From: Arjan van de Ven <arjan@infradead.org>
To: Adam Litke <agl@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070219183123.27318.27319.stgit@localhost.localdomain>
References: <20070219183123.27318.27319.stgit@localhost.localdomain>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 19 Feb 2007 19:43:01 +0100
Message-Id: <1171910581.3531.89.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 10:31 -0800, Adam Litke wrote:
> The page tables for hugetlb mappings are handled differently than page tables
> for normal pages.  Rather than integrating multiple page size support into the
> main VM (which would tremendously complicate the code) some hooks were created.
> This allows hugetlb special cases to be handled "out of line" by a separate
> interface.

ok it makes sense to clean this up.. what I don't like is that there
STILL are all the double cases... for this to work and be worth it both
the common case and the hugetlb case should be using the ops structure
always! Anything else and you're just replacing bad code with bad
code ;(

