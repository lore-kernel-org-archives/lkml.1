Return-Path: <linux-kernel-owner+w=401wt.eu-S1945943AbXEAVoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945943AbXEAVoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945962AbXEAVoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:44:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945943AbXEAVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:44:17 -0400
Date: Tue, 1 May 2007 14:43:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Triplett <josh@freedesktop.org>
cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: sparse -Wptr-subtraction-blows: still needed?
In-Reply-To: <4637AC3D.6000008@freedesktop.org>
Message-ID: <alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org>
References: <4637AC3D.6000008@freedesktop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 May 2007, Josh Triplett wrote:
> 
> Does this still apply?  Do current versions of GCC still have this problem?
> If not, can the option and warning go away?

Even if current versions of gcc don't triple the build time (and for the 
kernel, I suspect it doesn't, because we've tried to clean up our header 
files), the generated _code_ will invariably suck.

So I'd not want to remove the warning.

		Linus
