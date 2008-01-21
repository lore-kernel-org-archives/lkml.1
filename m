Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYAUGJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYAUGJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 01:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYAUGJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 01:09:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:48486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYAUGJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 01:09:01 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] x86_64: update e820 instead of updating end_pfn v2
Date: Mon, 21 Jan 2008 07:08:55 +0100
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200801192045.17291.yinghai.lu@sun.com> <200801210658.04030.ak@suse.de> <1200895558.5724.235.camel@brick>
In-Reply-To: <1200895558.5724.235.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801210708.55798.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > That change is good agreed, but I would suggest to put it into a separate
> > patch with a description
> > 
> 
> Perhaps like this:
> 
> if (l & (Tom2Enabled|Tom2ForceMemTypeWB))
> 	return 1;

That's not equivalent.

-Andi

