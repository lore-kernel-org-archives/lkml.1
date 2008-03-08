Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbYCHCAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbYCHCAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 21:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYCHCAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 21:00:03 -0500
Received: from relay2.sgi.com ([192.48.171.30]:58481 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753357AbYCHCAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 21:00:00 -0500
Date: Fri, 7 Mar 2008 17:59:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: David Rientjes <rientjes@google.com>, akpm@linux-foundation.org,
       Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 2/2] mempolicy: use default_policy mode instead of
 MPOL_DEFAULT
In-Reply-To: <20080307193543.6a55ff8d.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0803071754250.12037@schroedinger.engr.sgi.com>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0803071722170.4611@chino.kir.corp.google.com>
 <20080307192845.0492c6f9.pj@sgi.com> <alpine.DEB.1.00.0803071730340.6241@chino.kir.corp.google.com>
 <20080307193543.6a55ff8d.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And where is the patch to set the system (or cpuset....) default policy? 
;-)

Note that the system default policy changes during bootup. Could that be 
done with the default policy? We had some issues a while back with 
processes spawned at boot inheriting the interleave policy. If they could 
refer to default_policy instead then a change of default_policy would 
switch all spawned processes to use MPOL_DEFAULT?

