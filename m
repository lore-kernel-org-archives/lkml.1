Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXEGB2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXEGB2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXEGB2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:28:37 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:37404 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXEGB2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:28:37 -0400
Date: Mon, 7 May 2007 10:28:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/10] sh: dma: use __attribute_unused__
Message-ID: <20070507012814.GA26078@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:28:56PM -0700, David Rientjes wrote:
> There is no such thing as labeling a variable as __attribute__((used)).
> Since ts_shift is not referenced in inline assembly, we assume that we're
> simply suppressing a warning here if the variable is declared but
> unreferenced.
> 
> Cc: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
