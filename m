Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYFCRT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYFCRT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYFCRTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:19:50 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:45984 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYFCRTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:19:49 -0400
Date: Tue, 3 Jun 2008 20:19:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [Question] about modules/inline benefits
Message-ID: <20080603171922.GA2663@cs181133002.pp.htv.fi>
References: <4844C4D9.8030502@gawab.com> <g22rrs$6vp$1@ger.gmane.org> <200806030954.42188.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806030954.42188.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 09:54:41AM +0200, Oliver Neukum wrote:
> Am Dienstag 03 Juni 2008 09:28:59 schrieb Sitsofe Wheeler:
> > Modules allow you to support more hardware as there is a maximum size of the
> > core kernel image.
> 
> But you pay for every module with half a page of unused RAM and module
> code will be in vmalloced memory thus increases TLB pressure a bit.

Even more important, CONFIG_MODULES=y enlarges your kernel image by more 
than 5-10%, and you have to make _much_ stuff modular to compensate for 
this.

> 	Regards
> 		Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

