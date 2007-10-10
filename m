Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbXJJNr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbXJJNr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 09:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbXJJNrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 09:47:18 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:54018 "EHLO
	jankymail-a2.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752506AbXJJNrS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 09:47:18 -0400
Date: Wed, 10 Oct 2007 09:46:22 -0400
From: Gustavo Chain <g@0xff.cl>
To: David Newall <david@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reserve N process to root
Message-ID: <20071010094622.7b8121cf@0xff.cl>
In-Reply-To: <470C66A6.2060801@davidnewall.com>
References: <20071009194820.6c8d6e8d@0xff.cl>
	<470C2FA7.5030207@davidnewall.com>
	<20071010011523.7d6cca12@0xff.cl>
	<470C66A6.2060801@davidnewall.com>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 10 Oct 2007 15:14:06 +0930
David Newall <david@davidnewall.com> escribió:

> Gustavo Chain wrote:
> > El Wed, 10 Oct 2007 11:19:27 +0930
> > David Newall <david@davidnewall.com> escribió:
> >   
> >> Gustavo Chain wrote:
> >>     
> >>> I think it's necessary to reserve some pids to the super user.
> >>> 5 must be sufficient.
> >>>       
> >> Why?  (Sorry if I missed something.)
> >>     
> >
> > ¿ To prevent a posible DoS ?
> >   
> 
> That was what I thought you had in mind; it protects from some kind
> of fork bomb, right?  But it doesn't seem useful unless you guarantee 
> having a process already running (with CAP_SYS_ADMIN) *before* the
> bomb goes off.

Not really, because fork bomb will never reach maximum pid possible.
And root will always have a "slot" to kill desired processes.

-- 
Gustavo Chaín Dumit
