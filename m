Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbXGLGbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbXGLGbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXGLGbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:31:03 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37206 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbXGLGbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:31:00 -0400
Date: Thu, 12 Jul 2007 08:28:54 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch RT] Fix CFS load balancing for RT tasks
Message-ID: <20070712082854.12a385d3@frecb000686.frec.bull.fr>
In-Reply-To: <1184173580.12353.105.camel@chaos>
References: <20070711164708.48907792@frecb000686.frec.bull.fr>
	<1184173580.12353.105.camel@chaos>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 12/07/2007 08:35:23,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 12/07/2007 08:35:25,
	Serialize complete at 12/07/2007 08:35:25
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 19:06:20 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 2007-07-11 at 16:47 +0200, Sébastien Dugué wrote:
> >   The following patch fixes this by re-enabling the RT overload detection
> > for the CFS. It may not be the right solution, maybe it should be incorporated
> > into the other load balancing mechanisms. I did not digg deep enough yet
> > to make that call ;-)
> > 
> >   P.S. Thanks to Steven Rostedt for logdev which is proving invaluable in
> >        cases like this.
> > 
> >   Sébastien.
> 
> Nice catch. That was dropped during the CFS -> -rt merge.
> 
> 	tglx

  Thanks, and sorry, I forgot to CC you :(

  Sébastien.
