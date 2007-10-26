Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbXJZTCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbXJZTCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760322AbXJZTCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:02:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57695 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760102AbXJZTCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:02:22 -0400
Date: Fri, 26 Oct 2007 12:02:16 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071026120216.0411e7c0.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710261136500.11674@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<1193411888.5032.9.camel@localhost>
	<alpine.DEB.0.9999.0710261136500.11674@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> I personally prefer an approach where cpusets take the responsibility for 
> determining how policies change (they use set_mempolicy() anyway to effect 
> their mems boundaries) because it's cpusets that has changed the available 
> nodemask out from beneath the application.

Agreed.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
