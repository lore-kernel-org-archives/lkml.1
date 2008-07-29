Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbYG2VEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbYG2VEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYG2VEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:04:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:59555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYG2VEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:04:44 -0400
Date: Tue, 29 Jul 2008 14:04:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [patch 5/3] fastboot: sync the async execution before
 late_initcall and move level 6s (sync) first
Message-ID: <20080729140434.31022f55@infradead.org>
In-Reply-To: <488F84ED.9010200@keyaccess.nl>
References: <20080720085924.122feb2b@infradead.org>
	<20080720090041.5924f5ff@infradead.org>
	<488F84ED.9010200@keyaccess.nl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 23:00:29 +0200
> Isn't this a bit confusing? All the other sync levels are directly
> after their respective levels. I can see why you want another level
> now, but shouldn't that mean late_initcall now wants to be 8,
> device_initcall 7 and your new 6s just 6 (device_core_initcall or
> something...)?
> 

yeah it is.. but nobody is using them

I'll make a note to clean this up

(by removing the unused ones)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
