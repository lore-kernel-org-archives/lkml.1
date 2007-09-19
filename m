Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbXISRes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbXISRes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762233AbXISRd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:33:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58959 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762412AbXISRd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:33:26 -0400
Date: Wed, 19 Sep 2007 18:33:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 10/24] elevate write count during entire ncp_ioctl()
Message-ID: <20070919173325.GJ20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182731.822D5155@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182731.822D5155@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:31AM -0700, Dave Hansen wrote:
> 
> Some ioctls need write access, but others don't.  Make a helper
> function to decide when write access is needed, and take it.

The WARN_ON is too agressive because it'll happen whenever someone tries
a random, non-existant ioctl on ncpfs.  Otherwise the patch looks good.

