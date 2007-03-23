Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbXCWQY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbXCWQY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXCWQY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:24:27 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34484 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXCWQY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:24:26 -0400
Date: Fri, 23 Mar 2007 17:24:15 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Jean Delvare <khali@linux-fr.org>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: Xorg fails to start on 2.6.21-rc4-git7
In-Reply-To: <20070323171919.7260a5b6.khali@linux-fr.org>
Message-ID: <Pine.LNX.4.64.0703231723290.5030@twin.jikos.cz>
References: <20070323171919.7260a5b6.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Jean Delvare wrote:

> 2.6.21-rc4-git7 doesn't work on my laptop, git6 was OK. Symptop: the
> machine freezes as Xorg is started. A bisection led me there:
> 25496caec111481161e7f06bbfa12a533c43cc6f is first bad commit
> commit 25496caec111481161e7f06bbfa12a533c43cc6f
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Tue Feb 27 12:13:00 2007 -0500

Hi,

there have been other issues reproted with this patch, it is probably 
going to be reverted - see http://lkml.org/lkml/2007/3/23/104 and the 
thread that follows.

-- 
Jiri Kosina
