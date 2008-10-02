Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbYJBDn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbYJBDn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 23:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbYJBDnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 23:43:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:36148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYJBDnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 23:43:20 -0400
Date: Wed, 1 Oct 2008 20:43:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: auntvini@cel.usyd.edu.au
Cc: linux-kernel@vger.kernel.org
Subject: Re: Division of Load Average
Message-ID: <20081001204311.241e04e5@infradead.org>
In-Reply-To: <7971648.51222945125819.JavaMail.root@wombat.diezmil.com>
References: <7971648.51222945125819.JavaMail.root@wombat.diezmil.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 06:58:45 -0400
auntvini@cel.usyd.edu.au wrote:

> My self and my superviosr Dr David Levy have been working on
> introduction of new kernel code to correct the inherent problem of
> calculating load avarage by the current kernel. We have posted many
> e-mails in this regard since 2003 and kernel has been updated under
> the supervision of Rusty Russel.
> 
> Also we had interactions with IBM group(balbir@in.ibm.com)  who was
> engaged in delayed stat calculations.
> 
> We emphasise the following facts
> (1) seperation of Disk IO load from CPU load
> 
> This comes as a correction to the existing kernel as the calculation
> of the existing kernel load average is based on the arithmatic
> addition of Disk IO and CPU loads

while you can argue if including disk makes sense or not, it's 20+
years of tradition on Linux, and more on Unix.

So.. whatever you do (and I think there's some sense in splitting
things out).. please only *add* stats, don't replace the existing ones.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
