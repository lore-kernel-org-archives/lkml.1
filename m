Return-Path: <linux-kernel-owner+w=401wt.eu-S1765671AbXEYVFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765671AbXEYVFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758732AbXEYVFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:05:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55164 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbXEYVFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:05:06 -0400
Date: Fri, 25 May 2007 23:05:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org
Subject: Re: [PATCH 1/2] non-string based tsc unstable reasons
Message-ID: <20070525210504.GD24083@one.firstfloor.org>
References: <20070525193209.607200255@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525193209.607200255@mvista.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 12:32:10PM -0700, Daniel Walker wrote:
> Just passing a string to mark_tsc_unstable() doesn't allow real code to change
> based on the reason for the instablility. I changed mark_tsc_unstable()
> to accept a string and a flag which denotes a general reason why the tsc
> is unstable, and can be evaluated in code.
> 

I still think that's the wrong way to do this. If there is any 
special action that should be done on particular unstable events
it should call a separate function or an addon function.
First putting it all together and then try to distingush it again
doesn't seem nice.

-Andi
