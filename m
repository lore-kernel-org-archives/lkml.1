Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbXJ1TT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbXJ1TT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 15:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXJ1TTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 15:19:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:62377 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXJ1TTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 15:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c3Q2rcapKLbUkt52Y3AlFX7+94+Rdqu8GbTGpDS1CID9W2Dtdd5Nt12xdSgLPVCE5kNLHfErfNZiRoLvPMPuwyZxAYmSY42xDv/kw2brQpkN9QV7daKmr76e2Td1xoyyekq1Z61ZEB/NlU+jLOADJ0gzlUXzICeQrIQwldOS56o=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] QUESTION: How to fix race between .suspend routine and watchdog timer
Date: Sun, 28 Oct 2007 21:19:05 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0710271820240.2321-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0710271820240.2321-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710282119.05266.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 October 2007 00:24:10 Alan Stern wrote:
> On Sat, 27 Oct 2007, Maxim Levitsky wrote:
> 
> > > Use del_timer_sync().  It guarantees that when it returns, the timer 
> > > will be stopped and the timer routine will no longer be running on any 
> > > CPU.
> > > 
> > Even if the timer re-enables itself, are you sure?
> 
> Last time I looked at the source code, that's what it did.  I'll look
> again...  Yep, it still does.  It checks to see if the timer routine is
> currently running; if so then it waits a little while and tries again.
> 
> Alan Stern
> 
> 

Thanks, a lot,
	Best regards,
		Maxim Levitsky
