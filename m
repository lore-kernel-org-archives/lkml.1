Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYABJuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYABJuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbYABJuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:50:03 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3114 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbYABJuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:50:00 -0500
Date: Wed, 2 Jan 2008 09:49:56 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Benny Halevy <bhalevy@panasas.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: [PATCH] checkpatch.pl: recognize the #elif preprocessor directive
Message-ID: <20080102094956.GB23164@shadowen.org>
References: <477A1206.4070805@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477A1206.4070805@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 12:12:22PM +0200, Benny Halevy wrote:
> checkpatch.pl does not recognize #elif as a preprocessor directive
> causing it to print bogus errors for, e.g.:
> ERROR: need consistent spacing around '&' (ctx:WxV)
> when the operator is not recognized as unary in this context.
> 
> for example:
> 
> void foo(void)
> {
> 	int x, y, z;
> 	void *p[1] = {
> #if defined(X)
> 		&x
> #elif defined(Y)
> 		&y
> #else
> 		&z
> #endif
> 	};
> }
> 
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>

Yes, thanks; good catch.  Commited this and added tests for it.
Will be in 0.13 which is imminent.

-apw
