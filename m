Return-Path: <linux-kernel-owner+w=401wt.eu-S965693AbXC1TjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693AbXC1TjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXC1TjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:39:04 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:33929 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752701AbXC1TjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:39:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cXpRwf6FreA614c571c2TWoKgtT0Sv5tjR8Nn7WaiJxAX0NDxcofFRe6CAp8/H9nCfkKI4Z+gV7SkRWlx8tTY3IwfOhVt79iqxjUP+MnaciGYwAywleRv2urumLAlzmDJnVeqTUULaA+sP4cCFAMDtKR6wElICey8zTox39PBbY=  ;
X-YMail-OSG: EyzL7TkVM1mBPJSZgd.dq4DNW6.K0RvKP1JrAYtbaLkNRgDphOXvqhmF8ckDLIBukK6joemejg--
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [3/6] 2.6.21-rc4: known regressions
Date: Wed, 28 Mar 2007 12:38:55 -0700
User-Agent: KMail/1.7.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim <maximlevitsky@gmail.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       linux-ide@vger.kernel.org, gregkh@suse.de, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, linux-acpi@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, jgarzik@pobox.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703281701.23876.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703280931520.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703280931520.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703281238.57811.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 9:38 am, Linus Torvalds wrote:

> It's a *device*, dammit. It should save and resume like one (probably as a 
> system device). The "set_mode()" etc stuff is at a completely different 
> (higher) conceptual level.

Agreed, except about "probably as a system device".

Last I checked, there was no good reason to use sysdev suspend()/resume()
rather than platform_device suspend_late()/early_resume().  Which more
or less means no good reason to use sysdev in new code...


Also, making HPET use the legacy mode seems like a step backwards.

- Dave
