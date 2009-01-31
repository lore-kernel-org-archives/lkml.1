Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZAaRzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZAaRzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 12:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZAaRzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 12:55:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZAaRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 12:55:10 -0500
Date: Sat, 31 Jan 2009 12:55:09 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
       xfs@oss.sgi.com
Subject: Re: 2.6.28: All I/O, D-state: 3ware 9650SE-16ML/Intel/965/MTRR/PAT?
Message-ID: <20090131175509.GA24900@infradead.org>
References: <alpine.DEB.1.10.0901310523480.29879@p34.internal.lan> <alpine.DEB.1.10.0901311230510.4472@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901311230510.4472@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 12:37:39PM -0500, Justin Piszcz wrote:
> I think it was a coincidence when I tried to login before, I tried it  
> again (after trying to re-produce the problem, which I had been able to  
> do) and this time the mouse worked but the keyboard did not..even running
> echo b > sysrq-trigger did not reboot the server..  Had to resort to  
> manual method.
>
> I am now on kernel 2.6.28.2 and will see if I can make it happen again.

This looks like the bug fixed by commit
e8c82c2e23e3527e0c9dc195e432c16784d270fa.  Make sure you have it.

