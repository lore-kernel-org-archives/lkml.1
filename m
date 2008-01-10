Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbYAJPPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbYAJPPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYAJPPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:15:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41110 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbYAJPPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:15:36 -0500
Date: Thu, 10 Jan 2008 07:15:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
 traditional
Message-ID: <20080110071501.41dad3dd@laptopd505.fenrus.org>
In-Reply-To: <20080110124606.GD15156@elte.hu>
References: <20080109220508.686bbda4@laptopd505.fenrus.org>
	<1199946105.19760.5.camel@brick>
	<20080110124606.GD15156@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 13:46:06 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> > Arjan, I've been doing some work on traps_32.c porting over the 
> > oops_begin()/oops_end()/_die() arrangement from traps_64.c and then 
> > use it in unifying some more parts of fault.c.
> 
> i've got that applied and it did not seem to interact with Arjan's
> code.
> 
> > If you have other work in this area, I'll hold off until your stuff 
> > goes in...feel free to send me any work in progress stuff and I can 
> > try to coordinate with you.
> 
> i'll yell if anything clashes.


I have a few outstanding things but just go ahead; if you get there first I'll
resolve conflicts, if I get there first.. you'll have to ;-) It's not a big deal,
I'm trying to keep my changes to these areas really self contained small steps
because of the fragility (and because it's just a good idea in general), so any
clashes should also be easy to resolve either way

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
