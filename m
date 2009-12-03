Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZLCESD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZLCESD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbZLCESC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:18:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:48427 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZLCESB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:18:01 -0500
Date: Wed, 2 Dec 2009 20:20:12 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug (minor): microcode_intel.c applies updates to hyperthreaded
 cores
Message-ID: <20091202202012.0c7b6768@infradead.org>
In-Reply-To: <4B17393B.7000304@majjas.com>
References: <4B17393B.7000304@majjas.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Dec 2009 23:06:19 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> According to spec, microcode should only be applied to actual cores.
> As things are currently structured, looks like the fix would be in
> microcode_core.c. I don't think changing the loop to look for cores
> vs. cpu's would affect anything adversely, but honestly am not
> familiar enough with this code or other cpu types to be sure.
> 

isn't this

for each (logical) cpu
   check microcode version of the cpu
   if too old, apply microcode

the 2nd pair of a hyperthreading pair will never see the 'too old' case
happen...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
