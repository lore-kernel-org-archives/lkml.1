Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZGVRlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZGVRlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZGVRlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:41:22 -0400
Received: from n24.bullet.mail.mud.yahoo.com ([68.142.206.163]:47069 "HELO
	n24.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753663AbZGVRlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:41:19 -0400
X-Yahoo-Newman-Id: 782980.83209.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sEvf6cU7ehIB4eqJak0C18E569E90hIiB8mOOjoP5/pRaoNgegVTKj69luoBYsdTFAmpr3RQGi8liEyB6//sum8WVkzQ2nqwaIztJPic6blX6+y11WjxbC9szb4mmLKZJqMVOcmxO7qYzLU7CaQTIg3q3d8JFHf1LPkkqIV7GKk=  ;
X-YMail-OSG: 1XHZI.oVM1lji6yAWeZzqQ.JFi4qzhDAK.yDG0l0rEHgYCSWrOaGdaxe6cqWyjokDX2EIl.9uXZqmF3yn6QdA88sczkeWbYe_cCHr5xqxzIw_C00kL9tBdzl0sle.AzUzkQQW0VcnPXH_vOj4Ebh8lwSDayzcGozoI4BfneSrU2Ky4SXzWAGTsExPlznM_dTLPIlBp7StQfASRB2m7ZxaJUGYn8uBR76ov60TqiaAOiF5DEnSTsMHXLioVbRpGUaF32.dL1Eh_MswGRaE_Qzi2e_Xd_ZLy_g6nEU6FpGqyVF00N4sG19
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Date: Wed, 22 Jul 2009 10:41:18 -0700
User-Agent: KMail/1.9.10
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Peter Zijlstra <peterz@infradead.org>
References: <20090714100634.GA4054@elf.ucw.cz> <20090721160436.GD4352@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221041.19027.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Thomas Gleixner wrote:
> > >  - Multi-function devices like the twl4030 which have an interrupt
> > >    controller on them and would like to expose that interrupt controller
> > >    via the generic IRQ subsystem.  This was a large part of the
> > >    discussion in the thread above is a much trickier problem.
> 
> Why ?

Because the current threaded IRQ framework stops short of supporting
the relevant IRQ chaining mechanisms.

It handles the first level IRQ.  Not the second or third level
which needs to be dispatched from that one.

- Dave

