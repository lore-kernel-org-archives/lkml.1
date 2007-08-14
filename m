Return-Path: <linux-kernel-owner+w=401wt.eu-S935901AbXHNV6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935901AbXHNV6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933540AbXHNVjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:39:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48687 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934152AbXHNVjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:39:22 -0400
Date: Tue, 14 Aug 2007 14:39:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, bob.picco@hp.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
In-Reply-To: <1187127432.6281.135.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708141438410.31693@schroedinger.engr.sgi.com>
References: <20070812152126.GA26239@linux.vnet.ibm.com> 
 <20070813201215.GA16908@vino.hallyn.com>  <1187103831.6281.24.camel@localhost>
  <20070814180339.GA32553@vino.hallyn.com>  <1187115224.6281.40.camel@localhost>
  <20070814192306.GB32553@vino.hallyn.com>  <20070814204951.GA2065@vino.hallyn.com>
 <1187127432.6281.135.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Lee Schermerhorn wrote:

> Here's an update to that patch to handle the other 2 places I found
> where node_set_state() would be a no-op when MAX_NUMNODES == 1.

What is the problem? node_set_state is not needed when !NUMA. All flags
are set for the single node?
