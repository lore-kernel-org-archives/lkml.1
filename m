Return-Path: <linux-kernel-owner+w=401wt.eu-S1762336AbXJDXpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbXJDXpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbXJDXo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:44:58 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:10431 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326AbXJDXo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:44:57 -0400
X-IronPort-AV: E=Sophos;i="4.21,232,1188770400"; 
   d="scan'208";a="154952408"
Date: Fri, 5 Oct 2007 00:44:54 +0100
From: Derek Fawcus <dfawcus@cisco.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071005004454.A10105@mrwint.cisco.com>
References: <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org> <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil> <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org> <4702B1D5.5050502@tmr.com> <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org> <alpine.LFD.0.999.0710021615520.3579@woody.linux-foundation.org> <20071003011246.7313facb@the-village.bc.nu> <20071004235600.A4177@mrwint.cisco.com> <470574D7.6070605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Mailer: Mutt 1.0.1i
In-Reply-To: <470574D7.6070605@redhat.com>; from cebbert@redhat.com on Thu, Oct 04, 2007 at 07:18:47PM -0400
Authentication-Results: ams-dkim-1; header.From=dfawcus@cisco.com; dkim=pass (
	sig from cisco.com/amsdkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 07:18:47PM -0400, Chuck Ebbert wrote:
> > I ran firefox setuid to a different (not my main user),  uid+gid,  gave
> > my main account that gid as a supplemental group,  and gave that uid
> > access to the X magic cookie.
> 
> You need to use runxas to get any kind of real security.

Interesting script - sad how everyone reinvents equivalent things.

I had been experimenting with running the whole lot under Xnest,
with two extra users - one for the Xnest which had the main X
cookie, and another for the browser.  But found that it was just
too awkward (since I use multiple browser windows as well a tabs).

So I ended up trading a small security gain vs usablity.

The other thing I started playing with was the NX version of Xnest,
since it allows for a rootless server...

DF
