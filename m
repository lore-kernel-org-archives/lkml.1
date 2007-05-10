Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbXEJTbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbXEJTbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXEJTax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:30:53 -0400
Received: from mail.fieldses.org ([66.93.2.214]:35473 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbXEJTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:30:53 -0400
Date: Thu, 10 May 2007 15:30:50 -0400
To: Doug Chapman <doug.chapman@hp.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Marc Eshel <eshel@almaden.ibm.com>
Subject: Re: post 2.6.21 regression in F_GETLK
Message-ID: <20070510193050.GQ13719@fieldses.org>
References: <1178823375.7247.11.camel@dchapman.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178823375.7247.11.camel@dchapman.boston.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 02:56:15PM -0400, Doug Chapman wrote:
> A recent regression (introduced after 2.6.21) was caught by the LTP test
> fcntl11.  It appears that F_GETLK is not properly checking for existing
> F_RDLCK and allows taking out a write lock.

Ouch.

> This can be demonstrated by either running fcntl11 from the LTP suite or
> I have hacked up a much shorter version which demonstrates the issue and
> am attaching it.
> 
> Using git bisect I came up with this commit as the one that introduced
> the issue.

Thanks for the report--investigating....

--b.
