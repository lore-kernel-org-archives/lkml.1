Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbXDES3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbXDES3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXDES3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:29:33 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:29390 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbXDES3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:29:32 -0400
To: Tony Lindgren <tony@atomide.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
X-Message-Flag: Warning: May contain useful information
References: <11757088774110-git-send-email-tony@atomide.com>
	<20070404182728.GK29129@atomide.com>
	<20070404113925.da221efc.randy.dunlap@oracle.com>
	<20070404184455.GL29129@atomide.com>
	<20070404224448.0ff60ed2@the-village.bc.nu>
	<20070405132144.GC24297@atomide.com> <adar6qybx4y.fsf@cisco.com>
	<20070405180334.GW24297@atomide.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 05 Apr 2007 11:29:23 -0700
In-Reply-To: <20070405180334.GW24297@atomide.com> (Tony Lindgren's message of "Thu, 5 Apr 2007 14:03:36 -0400")
Message-ID: <adaslbe8ykc.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Apr 2007 18:29:23.0840 (UTC) FILETIME=[55A87000:01C777B0]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Hmm, yeah I'll see if I could group them a bit. The problem there
 > is that the patch series contains multiple rounds of "add and fix"
 > cycles. Pretty much all the non-dependant fixes have already been
 > applied, BTW.

I think it's nice to roll up fixes into patches that haven't been
merged upstream yet.  For example I try to avoid merging series like

  Add feature A
  Add feature B
  Fix 1 for feature A
  Fix 2 for feature A
  Fix for fix 1 for feature A

because that means I already knew the first patch was broken before it
ever got merged.  And it's better to avoid setting any more booby
traps for people trying to use git bisect or something like
that... enough bugs get merged by accident without us merging known
bugs.  So before I merge, I go back and create a new series like

  Add fixed feature A
  Add feature B

 - R.
