Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbXHHKVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbXHHKVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXHHKU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:20:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41031 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbXHHKU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:20:57 -0400
Date: Wed, 8 Aug 2007 12:20:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sheplyakov Alexei <varg@theor.jinr.ru>
Cc: Andi Kleen <andi@firstfloor.org>, dragoran <drago01@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070808102056.GC12861@one.firstfloor.org>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <20070808095132.GA31020@theor.jinr.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808095132.GA31020@theor.jinr.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 01:51:32PM +0400, Sheplyakov Alexei wrote:
> On Mon, Aug 06, 2007 at 01:11:01PM +0200, Andi Kleen wrote:
> 
> > Very low priority can starve others when it holds some kernel resource
> > needed by another task.  
> 
> Nevertheless ordinary users are permitted to lower priority ([re]nice)

Low priority as allowed by renice is ok -- the resource holder will 
run eventually and the system make progress.

> I don't quite understand. There are a lot of other ways to starve such
> high-priority process: 
> 1. renice the low-priority process

That requires user action.

e.g. if you google a bit you can find a famous story where the NASA
had to do that remotely to solve a PI problem on one of the Mars rovers. But I'm
sure they weren't very pleased about it. And not everybody has a JPL
control room to patch things up in the backhand.

> 2. send it a signal
> 3. ptrace it

Only root can do these.

-Andi

