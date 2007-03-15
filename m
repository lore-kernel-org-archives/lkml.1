Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXCOJPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXCOJPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 05:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXCOJPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 05:15:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51671 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbXCOJPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 05:15:05 -0400
Date: Thu, 15 Mar 2007 09:15:01 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       hch@infradead.org, Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH] Kprobes: Make kprobe.symbol_name const
Message-ID: <20070315091501.GA21823@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	Prasanna S Panchamukhi <prasanna@in.ibm.com>,
	Jim Keniston <jkenisto@us.ibm.com>
References: <20070315043547.GA14236@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315043547.GA14236@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 10:05:47AM +0530, Ananth N Mavinakayanahalli wrote:
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Kprobes doesn't scribble the kprobe.symbol_name field. Its only set by
> the module when registering the probe. Modules that exercise good
> hygiene using the "const" qualifier will see warnings...
> 
> 	warning: assignment discards qualifiers from pointer target type
> 
> Make struct kprobe.symbol_name const char *

Ok.

