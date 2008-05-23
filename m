Return-Path: <linux-kernel-owner+w=401wt.eu-S1761894AbYEWAcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894AbYEWAcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYEWAcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:32:33 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:25971 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759144AbYEWAcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:32:32 -0400
Date: Fri, 23 May 2008 09:30:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: dhowells@redhat.com, clameter@sgi.com, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] nommu: fix ksize() abuse
Message-ID: <20080523003049.GA8913@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka J Enberg <penberg@cs.helsinki.fi>, dhowells@redhat.com,
	clameter@sgi.com, mpm@selenic.com, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805221909050.4056@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805221909050.4056@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 07:11:40PM +0300, Pekka J Enberg wrote:
> The nommu binfmt code uses ksize() for pointers returned from do_mmap() 
> which is wrong. This converts the call-sites to use the nommu specific 
> kobjsize() function which works as expected.
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
