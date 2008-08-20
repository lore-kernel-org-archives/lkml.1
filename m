Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYHTPYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYHTPYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYHTPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:24:16 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:38485 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYHTPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:24:15 -0400
Subject: Re: slower initcalls in -next
From: Daniel Walker <dwalker@mvista.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h63pwnmno.wl%tiwai@suse.de>
References: <1219179084.18104.11.camel@dhcp32.mvista.com>
	 <s5h63pwnmno.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 08:24:11 -0700
Message-Id: <1219245851.18104.24.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 09:58 +0200, Takashi Iwai wrote:

> At least, all alsa_* calls are only for ISA devices, and I don't think
> it's worth to optimize.  Changing such hardcoded delays could break
> the running system easily.
> 
> However, some of the above are definitely interesting to investigate
> as they are mostly built-in and affect almost all people.

I didn't realize it till later , but the list is a little misleading ..
Those times are a mix of execution, and blocking.. I think the top one
(49 seconds!) was blocked most of the time, since ub_init() doesn't look
very complex. I'm not sure if it what it was blocked on, or why ..

Daniel

