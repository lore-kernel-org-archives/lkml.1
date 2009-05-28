Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbZE1N3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbZE1N3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZE1N3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:29:16 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:44936 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbZE1N3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:29:16 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Thu, 28 May 2009 08:29:13 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221721.08495.lkml@morethan.org> <20090528124853.GC1421@ucw.cz>
In-Reply-To: <20090528124853.GC1421@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905280829.15672.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu May 28 2009, Pavel Machek wrote:
> Hi!
> 
> > The observation that executing an unnecessary 'lock' opcode in some
> > cases slows down the machine is not felt by myself to be significant 
> > to duplicating my observations.  Note: I have been wrong before.
> > 
> > This is as informative as I can make the message.
> > 
> > PS: *not* a single machine failure, tested on five machines, owned
> > by four different people, two brands, with different use histories.
> 
> I have seen some problems on via c7m based machines, where some 'smart
> bios person' implemented EC access in AML (normally, it is accessed
> from ec.c driver). Maybe you have similary bad bios?
> 

How to tell or distingush?
Did your looking at the dmidecode output show you that?

Mike
