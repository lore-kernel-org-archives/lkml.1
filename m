Return-Path: <linux-kernel-owner+w=401wt.eu-S932315AbXCWQtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbXCWQtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934286AbXCWQte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:49:34 -0400
Received: from main.gmane.org ([80.91.229.2]:58452 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934281AbXCWQtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:49:33 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Date: Fri, 23 Mar 2007 16:48:56 +0000 (UTC)
Message-ID: <loom.20070323T174227-697@post.gmane.org>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu> <20070323101042.GD11577@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.60.176.179 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.3) Gecko/20070309 Firefox/2.0.0.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin <at> suse.de> writes:

> 
> On Fri, Mar 23, 2007 at 11:04:18AM +0100, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin <at> suse.de> wrote:
> > 
> > > Implement queued spinlocks for i386. [...]
> > 
> > isnt this patented by MS? (which might not worry you SuSE/Novell guys, 
> > but it might be a worry for the rest of the world 
> 
> I never thought a FIFO queue would be patentable.
> 
> Do you have a reference to the patent number?
> 

The ReactOS guys none the less, seem to have implemented queued spin locks -
http://www.reactos.org/en/newsletter_10.html (see the HAL section.)

Now I haven't looked at the code to see if they are different from what MS has
patented but given that it's a clone of Windows, one would think at least from
the behavioral pov they are similar?

Parag

