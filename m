Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbXDWISI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbXDWISI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXDWISI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:18:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45021 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbXDWISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:18:06 -0400
Date: Mon, 23 Apr 2007 09:17:53 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, chas@cmf.nrl.navy.mil,
       ecd@atecom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Message-ID: <20070423081753.GA27664@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Kyle Moffett <mrmacman_g4@mac.com>,
	Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	chas@cmf.nrl.navy.mil, ecd@atecom.com, linux-kernel@vger.kernel.org
References: <20070422213959.GP5013@traven> <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 07:50:36PM -0400, Kyle Moffett wrote:
> On Apr 22, 2007, at 17:39:59, Matthias Kaehlcke wrote:
> >use spinlock instead of binary mutex in idt77252 driver
> 
> I think you really meant: "Use mutex instead of binary semaphore in  
> idt77252 driver", since this is a binary semaphore (not a mutex,  
> which are always binary):

And the binary semaphore terminology i a little confusing. struct
semaphore is a full counting semaphore that is only used as a binary
semaphore if we want to speak in CS terms.  Than everyone else just
caled them semaphore before these patches started to show up :)

