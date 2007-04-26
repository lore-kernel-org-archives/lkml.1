Return-Path: <linux-kernel-owner+w=401wt.eu-S1031455AbXDZTM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031455AbXDZTM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031457AbXDZTM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:12:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53074 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031455AbXDZTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:12:27 -0400
Date: Thu, 26 Apr 2007 12:12:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
In-Reply-To: <4630F203.7020005@shadowen.org>
Message-ID: <Pine.LNX.4.64.0704261210430.7441@schroedinger.engr.sgi.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
 <4630A662.8090502@shadowen.org> <4630ABF2.1040305@shadowen.org>
 <4630EBFA.9000207@shadowen.org> <Pine.LNX.4.64.0704261123080.3560@schroedinger.engr.sgi.com>
 <4630F203.7020005@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Andy Whitcroft wrote:

> > But then how important is gcc 3.3 support?
> 
> Well we say 3.2 is the minimum.  If we simply return(NULL) or BUG() in

Oh before I forget

Gcc 3.3 works just fine on other platforms like i386. This is more likely 
a platform issue. If we disable it then only for <= gcc 3.3 on ppc. If 
problems crop up with other platforms then we can expand on it.
