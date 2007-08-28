Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbXH1SCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbXH1SCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbXH1SCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:02:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33251 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbXH1SCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:02:37 -0400
Date: Tue, 28 Aug 2007 19:02:35 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dean Nelson <dcn@sgi.com>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, jes@sgi.com
Subject: Re: [PATCH 4/4] add SGI Altix cross partition memory (XPMEM) driver
Message-ID: <20070828180235.GB32585@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dean Nelson <dcn@sgi.com>, tony.luck@intel.com,
	linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org, jes@sgi.com
References: <20070827155622.GA25589@sgi.com> <20070827164112.GF25589@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827164112.GF25589@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Big fat NACK, for dirty VM tricks, playing with task_struct lifetimes,
and last but not least the horrible ioctl "API".
