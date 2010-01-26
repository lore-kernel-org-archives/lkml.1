Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201Ab0AZUG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0AZUG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656Ab0AZUG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:06:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab0AZUG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:06:27 -0500
Date: Tue, 26 Jan 2010 12:05:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.33
Message-Id: <20100126120526.1950cbcf.akpm@linux-foundation.org>
In-Reply-To: <20100126125323.GR2014@erda.amd.com>
References: <20100125192922.GQ2014@erda.amd.com>
	<20100125232318.2f68a0ad.akpm@linux-foundation.org>
	<20100126125323.GR2014@erda.amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 13:53:24 +0100 Robert Richter <robert.richter@amd.com> wrote:

> On 25.01.10 23:23:18, Andrew Morton wrote:
> > On Mon, 25 Jan 2010 20:29:22 +0100 Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > Suravee Suthikulpanit (1):
> > >       oprofile/x86: fix crash when profiling more than 28 events
> > 
> > Did you consider a cc:stable on this one?
> 
> Yes, will send it to the stable tree after I got the upstream commit
> id.

You don't need to do that - simply add

Cc: <stable@kernel.org>

to the changelog and the -stable guys will later grab the commit by magic.
