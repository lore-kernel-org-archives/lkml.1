Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbXKAR02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbXKAR02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXKAR0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:26:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46389 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752920AbXKAR0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:26:19 -0400
Date: Thu, 1 Nov 2007 10:26:16 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
Message-Id: <20071101102616.826d45a1.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711011006070.29468@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
	<Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
	<20071031131949.b91bf383.pj@sgi.com>
	<Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
	<20071031214719.81f8293a.pj@sgi.com>
	<Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com>
	<20071031233352.959c32d0.pj@sgi.com>
	<Pine.LNX.4.64.0711010604210.27666@schroedinger.engr.sgi.com>
	<20071101090612.e0c86ddb.pj@sgi.com>
	<Pine.LNX.4.64.0711011006070.29468@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> The library interface can set flags to modify behavior.

A library such as libnuma can set them, yes, but not everyone uses
libnuma.  Basically everyone uses the standard C library, glibc, which
has the system call wrappers, but these wrappers should not be setting
optional flags.

We're going around in circles here, Christoph.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
