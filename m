Return-Path: <linux-kernel-owner+w=401wt.eu-S933195AbXBFSrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbXBFSrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933199AbXBFSrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:47:31 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:28223 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195AbXBFSra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:47:30 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1170786992.3785.0.camel@chaos>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 10:45:43 -0800
Message-Id: <1170787543.9781.362.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 19:36 +0100, Thomas Gleixner wrote:
> On Tue, 2007-02-06 at 08:03 -0800, Daniel Walker wrote:
> > It appears there a problem with the /proc/interrupts entry for
> > "timer" .. It doesn't increment anymore .. This problem exists in the
> > -rt tree also .. I haven't done a bisect , but I'm assuming this is HRT
> > related ..
> 
> And why should it increment ? Is there a rule that it has to ?

I don't know .. I would imagine some users might look at it and wonder
why there timer isn't ticking (I know it actually is ticking , but they
don't), when it has is every other kernel. 

We could just remove the timer entry .

Daniel

