Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXKATGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXKATGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXKATGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:06:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43577 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbXKATGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:06:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=mpIGZP0KiptbCssiqS31KXEsX/5ynufL4rSMzJxYtTmJQlH9pczcEK13d1vGhwk9O
	gEBGWBhbHFBw7eBW6wRwQ==
Date: Thu, 1 Nov 2007 12:06:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071101102616.826d45a1.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0711011204400.21823@chino.kir.corp.google.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com> <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com> <20071031131949.b91bf383.pj@sgi.com> <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
 <20071031214719.81f8293a.pj@sgi.com> <Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com> <20071031233352.959c32d0.pj@sgi.com> <Pine.LNX.4.64.0711010604210.27666@schroedinger.engr.sgi.com> <20071101090612.e0c86ddb.pj@sgi.com>
 <Pine.LNX.4.64.0711011006070.29468@schroedinger.engr.sgi.com> <20071101102616.826d45a1.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Paul Jackson wrote:

> A library such as libnuma can set them, yes, but not everyone uses
> libnuma.  Basically everyone uses the standard C library, glibc, which
> has the system call wrappers, but these wrappers should not be setting
> optional flags.
> 

I think what would end up happening is that additional functions would be 
added to libnuma that would effect the system-wide nodemask numbering by 
simply OR'ing the MPOL_F_MODE_SYS_WIDE flag as part of the mode actual.

		David
