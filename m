Return-Path: <linux-kernel-owner+w=401wt.eu-S1750847AbXBVLWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750847AbXBVLWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXBVLWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:22:12 -0500
Received: from colin.muc.de ([193.149.48.1]:4708 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbXBVLWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:22:11 -0500
Date: 22 Feb 2007 12:22:07 +0100
Date: Thu, 22 Feb 2007 12:22:07 +0100
From: Andi Kleen <ak@muc.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
Message-ID: <20070222112207.GA10190@muc.de>
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DD4FA0.5030205@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 12:09:04AM -0800, Jeremy Fitzhardinge wrote:
> Arjan van de Ven wrote:
> > Do we know how many gcc bugs this has? (regparm used to have many)
> > other than that.. sounds like a win...
> >   
> 
> The documentation suggests that its the preferred mode of operation, and
> that its the default on platforms where gcc is the primary compiler.  So
> the fact that it isn't for Linux suggests either an oversight or that it
> is actually broken...
> 
> Do we have much assembler which cares about the struct return calling
> convention?  If not, it should be a fairly easy test.

I didn't think we had any that returned structures.

-Andi
