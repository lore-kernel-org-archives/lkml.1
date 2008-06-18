Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYFRXU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYFRXU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 19:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYFRXUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:20:18 -0400
Received: from styx.suse.cz ([82.119.242.94]:44369 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752114AbYFRXUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:20:17 -0400
Date: Thu, 19 Jun 2008 01:20:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benny Halevy <bhalevy@panasas.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Request for discussion on when to merge
 drivers
In-Reply-To: <4859461A.7060003@panasas.com>
Message-ID: <alpine.LNX.1.10.0806190117090.4593@jikos.suse.cz>
References: <1213802866.3515.24.camel@localhost.localdomain> <4859461A.7060003@panasas.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, Benny Halevy wrote:

> Exposing the not-yet-ready-to-be-released code to linux-next will expose 
> conflicts earlier, and hopefully in smaller, more manageable deltas.

I like the way linux-next works now, i.e. it should reflect what is going 
into the next major kernel release. Nothing more, nothing less.

Also, when talking about entirely new drivers for hardware that hasn't 
been supported by the kernel at all so far (this is the situation we are 
talking about, right?), there shouldn't be a lot of conflicts to be dealt 
with, right? Ideally, drivers should be pretty isolated standalone pieces 
of code that don't have any business changing any code that has been 
already there.

-- 
Jiri Kosina
SUSE Labs
