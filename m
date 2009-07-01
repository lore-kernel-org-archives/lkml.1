Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZGAIIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZGAIIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZGAIIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:08:36 -0400
Received: from mail.opencsw.org ([147.87.98.73]:61385 "EHLO mail.opencsw.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZGAIIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:08:35 -0400
Date: Wed, 1 Jul 2009 10:08:34 +0200
From: Attila Kinali <attila@kinali.ch>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Long lasting MM bug when swap is smaller than RAM
Message-Id: <20090701100834.1f740ad5.attila@kinali.ch>
In-Reply-To: <20090701100432.2d328e46.attila@kinali.ch>
References: <20090630115819.38b40ba4.attila@kinali.ch>
	<4A4ABD8F.40907@gmail.com>
	<20090701100432.2d328e46.attila@kinali.ch>
Organization: GEHIRN
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 10:04:32 +0200
Attila Kinali <attila@kinali.ch> wrote:

> > But 
> > swapping does not only occur if memory is running low. If disk usage is 
> > high then non-recently used data may be swapped out to make more room 
> > for disk caching.
> 
> Hmm..I didn't know this.. thanks!

This was the cause of the problem!

I just restarted svnserv, clamav and bind (the three applications
using most memory) and suddenly swap cleared up.

Now the question is, why did they accumulate so much used swap
space, while before the RAM upgrade, we hardly used the swap space at all?

		Attila Kinali
