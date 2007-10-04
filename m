Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbXJDEif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbXJDEif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXJDEi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:38:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40593 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbXJDEi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:38:26 -0400
Date: Wed, 3 Oct 2007 21:36:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@suse.de, travis@sgi.com
Subject: Re: [14/18] Configure stack size
Message-ID: <20071003213631.7a047dde@laptopd505.fenrus.org>
In-Reply-To: <20071004040004.936534357@sgi.com>
References: <20071004035935.042951211@sgi.com>
	<20071004040004.936534357@sgi.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Oct 2007 20:59:49 -0700
Christoph Lameter <clameter@sgi.com> wrote:

> Make the stack size configurable now that we can fallback to vmalloc
> if necessary. SGI NUMA configurations may need more stack because
> cpumasks and nodemasks are at times kept on the stack. With the
> coming 16k cpu support this is going to be 2k just for the mask. This
> patch allows to run with 16k or 32k kernel stacks on x86_74.

there is still code that does DMA from and to the stack....
how would this work with virtual allocated stack?
