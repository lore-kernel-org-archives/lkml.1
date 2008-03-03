Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYCCMGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYCCMGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYCCMGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:06:23 -0500
Received: from styx.suse.cz ([82.119.242.94]:37592 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751279AbYCCMGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:06:23 -0500
Date: Mon, 3 Mar 2008 13:06:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Olsa <olsajiri@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>, peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
In-Reply-To: <47CBE871.4090309@gmail.com>
Message-ID: <Pine.LNX.4.64.0803031305090.15209@jikos.suse.cz>
References: <47C7E280.4010805@gmail.com> <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz>
 <47CAE7D5.5040907@gmail.com> <20080302120236.61e0ec74.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz>
 <Pine.LNX.4.64.0803022223360.15209@jikos.suse.cz> <47CBE871.4090309@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Jiri Olsa wrote:

> I'll try the patch, so far I attached the ipcs strace and adjacent kernel logs.

Thanks for the strace.

The kernel oopses showing the soft lockup happen at the time of the first 
segfaulting run of ipcs, or the second one that hangs?

The oopses are different compared to the ones you posted previously -- 
those were clearly poiting to use-after-free, these show spinlock lockup.

-- 
Jiri Kosina
SUSE Labs
