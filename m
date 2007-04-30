Return-Path: <linux-kernel-owner+w=401wt.eu-S1422996AbXD3Eyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422996AbXD3Eyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 00:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422984AbXD3Eyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 00:54:33 -0400
Received: from gw.goop.org ([64.81.55.164]:35133 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422996AbXD3Eyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 00:54:31 -0400
Message-ID: <46357694.2030206@goop.org>
Date: Sun, 29 Apr 2007 21:54:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Zachary Amsden <zach@vmware.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 03/32] xen: Add nosegneg capability to the vsyscall page
 notes
References: <20070429190830.0CF571801A4@magilla.sf.frob.com>
In-Reply-To: <20070429190830.0CF571801A4@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I wouldn't add that macro to asm/elf.h.  There is nothing magical or
> standard about that number.
>   

It was just there for a later patch to set/clear the mask dynamically
depending on whether we're running under Xen.  But I haven't implemented
that yet.

    J
