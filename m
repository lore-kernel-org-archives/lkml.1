Return-Path: <linux-kernel-owner+w=401wt.eu-S1767016AbXCIMFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767016AbXCIMFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767000AbXCIMFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:05:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767016AbXCIMFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:05:14 -0500
Date: Fri, 9 Mar 2007 07:05:06 -0500
From: Alan Cox <alan@redhat.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] revoke: consolidate revoked file operations
Message-ID: <20070309120506.GA3101@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0703091353450.13990@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703091353450.13990@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 01:55:06PM +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Return EBADF for all revoked file operations except for read(2) which
> returns zero for special files as the BSDs do and close(2) which is 
> always zero.
> 
> Cc: Alan Cox <alan@redhat.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: Alan Cox <alan@redhat.com>
