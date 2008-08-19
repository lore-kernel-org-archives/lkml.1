Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYHSNEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYHSNEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYHSNEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:04:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbYHSNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:04:16 -0400
Message-ID: <48AAC44A.5000204@linux-foundation.org>
Date: Tue, 19 Aug 2008 08:02:02 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: BUG in free_block (tainted)
References: <48A9E97B.6060601@simon.arlott.org.uk>	 <84144f020808181437n34f3a339j3392ccccfdfd60f9@mail.gmail.com>	 <48A9ECD2.8030801@simon.arlott.org.uk> <84144f020808181449i546349b9n248b5cf5399e4b0f@mail.gmail.com>
In-Reply-To: <84144f020808181449i546349b9n248b5cf5399e4b0f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
 perhaps it can detect that bug...
> 
> Aww, apparently the fglrx driver creates tons of SLAB caches with
> really funky names for no good reason... Oh well, one more reason to
> stay away from that crap and help out the nouveau folks instead ;-).

Could you give SLUB a try? Diagnostics are better. Lets see what it spits out.

