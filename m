Return-Path: <linux-kernel-owner+w=401wt.eu-S1764366AbZDHUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764366AbZDHUrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbZDHUrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:47:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbZDHUrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:47:02 -0400
Date: Wed, 8 Apr 2009 13:44:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: checkpatch fixes
In-Reply-To: <200904082157.54134.borntraeger@de.ibm.com>
Message-ID: <alpine.LFD.2.00.0904081341090.4583@localhost.localdomain>
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com> <alpine.LFD.2.00.0904081007530.4583@localhost.localdomain> <200904082157.54134.borntraeger@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Apr 2009, Christian Borntraeger wrote:
> 
> Isnt checkpatch just following what is written down in the Documentation 
> folder? Maybe adopting the following part of CodingStyle and add more 
> examples for good and bad would give the checkpatch authors a better 
> idea about your intent.

The thing is, it's true that it's good if things fit in 80 columns.

But _splitting_ lines isn't the answer. Making code simpler is, but 
somehow the 80-column warning never causes that to happen - instead people 
just split.

And yes, I guess we should remove the language saying so. It's not from 
my original coding stule, it was added later by others, and came through 
Andrew (commit 560362dafe4de60db70f2c298a53f4613453a78b: "[PATCH] 
Codingstyle update" in the historical Linux archive).

			Linus
