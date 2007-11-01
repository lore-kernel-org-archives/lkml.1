Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbXKARox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbXKARox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXKARop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:44:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48518 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752461AbXKARoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:44:44 -0400
Date: Thu, 1 Nov 2007 10:44:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071101102616.826d45a1.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0711011040030.29895@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
 <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
 <20071031131949.b91bf383.pj@sgi.com> <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
 <20071031214719.81f8293a.pj@sgi.com> <Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com>
 <20071031233352.959c32d0.pj@sgi.com> <Pine.LNX.4.64.0711010604210.27666@schroedinger.engr.sgi.com>
 <20071101090612.e0c86ddb.pj@sgi.com> <Pine.LNX.4.64.0711011006070.29468@schroedinger.engr.sgi.com>
 <20071101102616.826d45a1.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Paul Jackson wrote:

> Christoph wrote:
> > The library interface can set flags to modify behavior.
> 
> A library such as libnuma can set them, yes, but not everyone uses
> libnuma.  Basically everyone uses the standard C library, glibc, which
> has the system call wrappers, but these wrappers should not be setting
> optional flags.
> 
> We're going around in circles here, Christoph.

Yes and you keep missing the point focusing on stuff that is not relevant.
Where did you get the rule that libraries should not be setting flags? 
libraries do all sort of conversion before calling the kernel API.

Look the libraries are a strong argument against the method of setting 
task flags. If you are using multiple libraries some of which have been 
updated and some of those which have not then setting a task flag can 
have bad consequences. You want clean syscall behavior.
