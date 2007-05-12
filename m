Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbXELS7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbXELS7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbXELS6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:58:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:45104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756AbXELS6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:58:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 1/2] non-string based tsc unstable reasons
Date: Sat, 12 May 2007 20:56:42 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com, mingo@elte.hu
References: <20070512154344.395866578@mvista.com>
In-Reply-To: <20070512154344.395866578@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705122056.42926.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2007 17:43:45 Daniel Walker wrote:
> Just passing a string to mark_tsc_unstable() doesn't allow real code to change
> based on the reason for the instablility. I changed mark_tsc_unstable()
> to accept a string and a flag which denotes a general reason why the tsc
> is unstable, and can be evaluated in code.
> 
> This is based off John Stultz patch to add the string reasons.

This seems ugly -- it would be better to just do whatever needs to
be doing in the caller instead of passing down a enum and then switch.

And why do you really need it anyways?

-Andi
