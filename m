Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYFNVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYFNVSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYFNVSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:18:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:41807 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbYFNVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:18:15 -0400
Date: Sat, 14 Jun 2008 14:18:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "werner" <werner@sys-linux.yi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regressions in the last kernels
Message-ID: <20080614141805.30cf74f0@infradead.org>
In-Reply-To: <1213467969.31034@sys-linux.yi.org>
References: <1213467969.31034@sys-linux.yi.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2008 15:26:09 -0300 (GFT)
"werner" <werner@sys-linux.yi.org> wrote:

> During preparation and own testing for my distro; installation on
> computers for neighbours, by reclamations by users, I learned about
> the following problems of 2.6.26-rcX :
> 
> 1) When compiling for i486,  one cannot select/configurate more
> memory than 4 GB, menuconfig don't show items with higher values.  My
> own computer/server has 8 GB, but when I compile the kernel with 4 GB
> and i486 then 'free' shows only 3.2 GB (no shared grafics, the grafic
> card has its own memory) ...


interesting problem... 486's didn't have PAE so are limited to 4Gb of
memory... makes this a policy question more than a bug...
(in fact, if you configure for > 4Gb a 486 CPU will not boot... so
arguably the new behavior is correct!!!)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org


