Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZHZVhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZHZVhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZHZVhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:37:50 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:50740 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZHZVht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QYPiSi4orAnq5CGhI9sN9Lgw3643lZpCdBXu9UmTQ95e7uPK1O8/bx7Rj5G7wsk84Q
         Oj6AzDTSEV2nVP9eI0rluNVtg7UQKmObDBjjo9N7bIZ49IfY/QQphVPNNjtDHqY9HDYa
         bgWRYjGrL5ts5sSieEVT0fpEVKAGRLhEif7KU=
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <4A95A5EE.90400@nortel.com>
References: <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop>	<1251298443.4791.7.camel@raz>
	 <1251300625.18584.18.camel@twins>
	 <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
	 <1251302598.18584.31.camel@twins>
	 <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
	 <20090826180407.GA13632@elte.hu>
	 <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
	 <20090826193252.GA14721@elte.hu>
	 <alpine.DEB.1.10.0908261627110.5554@gentwo.org>
	 <20090826135041.e6169d18.akpm@linux-foundation.org>
	 <4A95A5EE.90400@nortel.com>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 00:37:43 +0300
Message-Id: <1251322663.3882.48.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-08-26 at 15:15 -0600, Chris Friesen wrote:
> On 08/26/2009 02:50 PM, Andrew Morton wrote:
> 
> > What problem?
> > 
> > All I've seen is "I want 100% access to a CPU".  That's not a problem
> > statement - it's an implementation.
> > 
> > What is the problem statement?
> 
> I can only speak for myself...
> 
> In our case the problem statement was that we had an inherently
> single-threaded emulator app that we wanted to push as hard as
> absolutely possible.
> 
> We gave it as close to a whole cpu as we could using cpu and irq
> affinity and we used message queues in shared memory to allow another
> cpu to handle I/O.  In our case we still had kernel threads running on
> the app cpu, but if we'd had a straightforward way to avoid them we
> would have used it.
> 
> Chris
Chris. I offer myself to help anyone wishes to apply OFFSCHED.
  



