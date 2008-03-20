Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbYCTEG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbYCTEG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYCTEGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:06:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYCTEGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:06:49 -0400
Date: Wed, 19 Mar 2008 21:04:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [1/2] vmalloc: Show vmalloced areas via /proc/vmallocinfo
Message-ID: <20080319210436.191bb8fe@laptopd505.fenrus.org>
In-Reply-To: <20080318222827.291587297@sgi.com>
References: <20080318222701.788442216@sgi.com>
	<20080318222827.291587297@sgi.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 15:27:02 -0700
Christoph Lameter <clameter@sgi.com> wrote:

> Implement a new proc file that allows the display of the currently
> allocated vmalloc memory.

> +	proc_create("vmallocinfo",S_IWUSR|S_IRUGO, NULL,


why should non-root be able to read this? sounds like a security issue (info leak) to me...




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
