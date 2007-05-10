Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbXEJTOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbXEJTOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbXEJTOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:14:34 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:47172 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbXEJTOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:14:33 -0400
Subject: Re: post 2.6.21 regression in F_GETLK
From: Doug Chapman <doug.chapman@hp.com>
To: linux-kernel@vger.kernel.org
Cc: bfields@citi.umich.edu, hch@infradead.org, doug.chapman@hp.com
In-Reply-To: <1178823375.7247.11.camel@dchapman.boston.redhat.com>
References: <1178823375.7247.11.camel@dchapman.boston.redhat.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 15:14:23 -0400
Message-Id: <1178824463.7247.13.camel@dchapman.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-34.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 14:56 -0400, Doug Chapman wrote:
> A recent regression (introduced after 2.6.21) was caught by the LTP test
> fcntl11.  It appears that F_GETLK is not properly checking for existing
> F_RDLCK and allows taking out a write lock.
> 
> This can be demonstrated by either running fcntl11 from the LTP suite or
> I have hacked up a much shorter version which demonstrates the issue and
> am attaching it.
> 

I should add that I have seen this on ia64 and x86_64.  I do not
currently have any 32 bit systems to test on.

- Doug


