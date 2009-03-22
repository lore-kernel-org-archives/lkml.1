Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZCVTqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZCVTqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZCVTqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:46:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:57978 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbZCVTqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:46:01 -0400
Date: Sun, 22 Mar 2009 12:46:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Eric Dumazet <dada1@cosmosbay.com>, dipankar@in.ibm.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090322124632.5d5d6266@infradead.org>
In-Reply-To: <20090322165324.GH7148@linux.vnet.ibm.com>
References: <20090320111354.679ab53d@infradead.org>
	<20090321012746.GM6698@linux.vnet.ibm.com>
	<20090321125115.0a76ac27@infradead.org>
	<49C54D60.80306@cosmosbay.com>
	<20090321210745.GE7148@linux.vnet.ibm.com>
	<20090321204045.4a9022fd@infradead.org>
	<20090322043838.GF7148@linux.vnet.ibm.com>
	<20090321215109.717a3f12@infradead.org>
	<20090322051822.GG7148@linux.vnet.ibm.com>
	<20090321225318.5b25f0a7@infradead.org>
	<20090322165324.GH7148@linux.vnet.ibm.com>
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

On Sun, 22 Mar 2009 09:53:24 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> > > How many synchronize_rcu() calls are you seeing on the boot path?
> > 
> > I see 20 that hit the above code path (eg ones that wait) until
> > userspace starts.
> 
> So with well-behaved readers, the full sequence would be worth
> something like 50-60 milliseconds.

yeah it's about 10% if the total kernel boot time.. so it does start to
matter

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
