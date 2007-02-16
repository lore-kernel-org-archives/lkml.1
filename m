Return-Path: <linux-kernel-owner+w=401wt.eu-S1946245AbXBPVNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946245AbXBPVNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946247AbXBPVNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:13:45 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37582 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1946245AbXBPVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:13:44 -0500
Date: Fri, 16 Feb 2007 13:13:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Zachary Amsden <zach@vmware.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for
 paravirt_ops interface
In-Reply-To: <45D61C74.2000601@vmware.com>
Message-ID: <Pine.LNX.4.64.0702161312460.28871@schroedinger.engr.sgi.com>
References: <20070216022449.739760547@goop.org>
 <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com>
 <45D61C74.2000601@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Zachary Amsden wrote:

> For the most part, it doesn't disturb VMware or KVM.  Xen does need some
> additional functionality in paravirt-ops because they took a different design
> choice - direct page tables instead of shadow page tables.  This is where all
> the requirements for the new Xen paravirt-ops hooks come from.

It still seems to be implemented for Xen and not to support a variety of 
page table methods in paravirt ops.

