Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZEQTej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZEQTej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZEQTeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:34:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:42536 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbZEQTeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:34:23 -0400
Date: Sun, 17 May 2009 12:33:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: david@lang.hm
Cc: devzero@web.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Where do we stand with the Xen patches?
Message-ID: <20090517123324.2e57bc55@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0905171223250.26653@asgard>
References: <720338507@web.de>
	<alpine.DEB.1.10.0905171223250.26653@asgard>
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

On Sun, 17 May 2009 12:25:38 -0700 (PDT)
david@lang.hm wrote:

> On Sun, 17 May 2009, devzero@web.de wrote:
> > maybe this is iust a stupid comment (please forgive, i?m no
> > advanced kernel hacker), but can?t the code inserted by the patches
> > and which changes the fastpath just #IFDEF`ed at the critical
> > offsets ?  (as building a dom0 kernel is just another build target,
> > isn`t it ?)
> 
> no, if dom0 is going to be widely deployed, it will be because the
> distros turn on dom0 support by default. as a result any penalties
> due to xen support will be felt by all users of those distros (even
> if they don't use xen)
> 

at minimum we need to split CONFIG_PARAVIRT up into 
"want to be nice to hypervisors" and "I want to be Xen Dom0";
they look to largely not overlap.... so lets not make the costs overlap
either.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
