Return-Path: <linux-kernel-owner+w=401wt.eu-S1762384AbXEJWOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762384AbXEJWOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXEJWOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:14:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbXEJWOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:14:39 -0400
Message-ID: <46439941.4010909@redhat.com>
Date: Thu, 10 May 2007 17:14:25 -0500
From: David Smith <dsmith@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Smith <dsmith@redhat.com>
Subject: Re: [patch 03/10] Allow userspace applications to use marker.h to
 parse the markers section in the kernel binary.
References: <20070510015555.973107048@polymtl.ca> <20070510020915.900170085@polymtl.ca> <20070510065137.GA7943@infradead.org>
In-Reply-To: <20070510065137.GA7943@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> NACK.  This shouldn't be includedable from userspace and systemtap people
> should stop doing crap like that but use kernel infrastructure everyone
> else uses including runtime kernel code instead of stuffin all kinds of
> crap into their broken translator.

Christoph,

I was using the above information to parse all the available markers in 
a kernel, but I believe I've found a way where I don't need the marker.h 
header, so I'm OK with your NACK.

Out of curiosity, what is the kernel infrastructure you believe I should 
be using to get a list of all available markers in a kernel?  Note that 
I also have a requirement to get a list of all available markers in a 
kernel that isn't the currently running one.

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
