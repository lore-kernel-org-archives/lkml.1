Return-Path: <linux-kernel-owner+w=401wt.eu-S935551AbXHNVwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbXHNVwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762184AbXHNV2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:28:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35381 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762005AbXHNV2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:28:38 -0400
Date: Tue, 14 Aug 2007 14:28:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, bob.picco@hp.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
In-Reply-To: <20070814204951.GA2065@vino.hallyn.com>
Message-ID: <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
References: <20070812152126.GA26239@linux.vnet.ibm.com>
 <20070813201215.GA16908@vino.hallyn.com> <1187103831.6281.24.camel@localhost>
 <20070814180339.GA32553@vino.hallyn.com> <1187115224.6281.40.camel@localhost>
 <20070814192306.GB32553@vino.hallyn.com> <20070814204951.GA2065@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Serge E. Hallyn wrote:

> CONFIG_NODES_SHIFT was unset, so MAX_NUMNODES=1, so
> node_state() and node_set_state() are dummies.

Ok then you did not have a NUMA system configured. So its okay for the 
dummies to ignore the stuff. CONFIG_NODES_SHIFT is a constant and does not 
change. The first bit is always set.

