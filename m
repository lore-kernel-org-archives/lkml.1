Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZDPBaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZDPBaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZDPB3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:29:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:55636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZDPB3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:29:52 -0400
Date: Wed, 15 Apr 2009 18:31:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: How to completely disable async fastboot?
Message-ID: <20090415183137.4d19a7c8@infradead.org>
In-Reply-To: <49E679D0.7050600@garzik.org>
References: <49E679D0.7050600@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 20:20:32 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> The following commit
> 
> > commit 9710794383ee5008d67f1a6613a4717bf6de47bc
> > Author: Arjan van de Ven <arjan@linux.intel.com>
> > Date:   Sun Mar 15 11:11:44 2009 -0700
> > 
> >     async: remove the temporary (2.6.29) "async is off by default"
> > code
> 
> not only changes a default, it completely removes the ability to turn 
> off async AFAICS.

this is on the request of Andrew and others who want to be able to use
these API's (soon) in an "forced offload" scenario. 

> 
> At present, I need to turn this off to debug boot-time operation.

can you give some details? Maybe I can help suggest things...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
