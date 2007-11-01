Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbXKAIDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbXKAIDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbXKAIDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:03:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60600 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXKAID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:03:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=Ta9TCAoop3czzQn+jFH4gwgVjDregaR8oGIxPFWeWGVTz289qFEsldM51AhqRsKxD
	0DW3YJak4Clt6qzmj34pg==
Date: Thu, 1 Nov 2007 01:03:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071031233352.959c32d0.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0711010055090.2973@chino.kir.corp.google.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com> <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com> <20071031131949.b91bf383.pj@sgi.com> <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
 <20071031214719.81f8293a.pj@sgi.com> <Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com> <20071031233352.959c32d0.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Paul Jackson wrote:

>     David R - is your use of the mbind and *_mempolicy system calls
>     via libnuma, or direct system calls?
> 

I hope to be able to use libnuma exclusively once your fix is in place so 
that the interleaving behaves the way we want while attached to a changing 
cpuset.  (And it would be preferable to not have to use a special version 
of it that is hacked to support the fix.)  It's just simpler to use as an 
interface, but I wouldn't consider using the system calls directly an 
error.

		David
