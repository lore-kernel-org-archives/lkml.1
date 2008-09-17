Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYIQILg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYIQILg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYIQILV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:11:21 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:24154 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751432AbYIQILT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:11:19 -0400
X-YMail-OSG: Q8de91AVM1kKdw.YIq2T.ZzQEUbCF_VIipsgFj.l_0cRZd0M7XsHXhMvl4yE9Ox1aQk8sA2p8xTJnNEXlXVMw41KxJ8xgeFdD404TKY1w6iEt3_q30p6SgE.VE0uaKw-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Wed, 17 Sep 2008 01:11:17 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: How to find out, what "pdflush" is working on
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <33099.10057.qm@web32603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Chris Snook <csnook@redhat.com>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: linux-kernel@vger.kernel.org; Peter zijlstra <a.p.zijlstra@chello.nl>; Fengguang Wu <wfg@mail.ustc.edu.cn>
> Sent: Tuesday, September 16, 2008 9:07:29 PM
> Subject: Re: How to find out, what "pdflush" is working on
> 
> Martin Knoblauch wrote:
> > Hi,
> > 
> > I find the following comment in mm/pdflush.c
> > 
> > /* * The pdflush threads are worker threads for writing back dirty data. *
> > Ideally, we'd like one thread per active disk spindle.  But the disk *
> > topology is very hard to divine at this level.   Instead, we take * care in
> > various places to prevent more than one pdflush thread from * performing
> > writeback against a single filesystem.  pdflush threads * have the PF_FLUSHER
> > flag set in current->flags to aid in this. */
> > 
> > Is there a way to find out what a certain instance of "pdflush" is working
> > on? Like which block-device or which fliesystem it is writing to? I am still
> > (2.6.27) trying to track down why writing a single file can make linux very
> > sluggish and unresponsive. If that happens I usually see all possible 8
> > "pdflush" threads being in "D"-state. According to above comment only one of
> > them should be really busy.
> 
> The key word is "ideally".  We'd like it to work that way, but it doesn't. 
> Patches to fix this are welcome.
> 

 Now, I am pretty much aware that apparently things are not "ideal". Therefore my question. Because before doing patches, one has to analyze.

Cheers
Martin

