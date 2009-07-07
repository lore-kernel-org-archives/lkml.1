Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbZGGNSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbZGGNSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZGGNSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:18:18 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:47293 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZGGNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xn2Xay5mGQcm412no/TC447u7aXMsSPzHum+flxxKSKzqht2sWq6004pff56np2rNn
         LF8ruiNUBrsDv9gKutDZFUV7+1Bp7FGNV/JjPUhxi0UFiP9eE+i2JDmq681rnFJD9pT6
         IkQHKjGExkPhxTuXKbVbpZfXzAifXPezN9qrY=
Date: Tue, 7 Jul 2009 15:18:03 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andres Freund <andres@anarazel.de>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090707131803.GA6520@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <20090706163106.GA4559@ami.dom.local> <a5d9929e0907061023g4306d80ewfc8907653b949005@mail.gmail.com> <200907061926.43625.andres@anarazel.de> <20090707065014.GA3296@ami.dom.local> <a5d9929e0907070340y63280508t92e6c7e4ce464994@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d9929e0907070340y63280508t92e6c7e4ce464994@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 11:40:16AM +0100, Joao Correia wrote:
> I am now running 2.6.31-rc2 for a couple of hours, no freeze.
> 
> Let me know what/if i can help with tracking down the original source
> of the problem.

OK, so we know it's only about timers. Here is another tiny patch
(the previous one should be removed), which could tell (with oops) if
there's something while migrating. Anyway, the bug should be back :-(

Thanks,
Jarek P.
