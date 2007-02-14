Return-Path: <linux-kernel-owner+w=401wt.eu-S1751413AbXBNFwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbXBNFwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 00:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXBNFwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 00:52:15 -0500
Received: from ozlabs.org ([203.10.76.45]:55369 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbXBNFwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 00:52:14 -0500
Subject: Re: [patch 10/21] Xen-paravirt: Name: dont export paravirt_ops
	structure, do individual functions
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <45D260A2.4010200@vmware.com>
References: <20070213221729.772002682@goop.org>
	 <20070213221830.238235953@goop.org>  <45D260A2.4010200@vmware.com>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 16:51:20 +1100
Message-Id: <1171432280.19842.113.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 17:06 -0800, Zachary Amsden wrote:
> Jeremy Fitzhardinge wrote:
> > Wrap the paravirt_ops members we want to export in wrapper functions.
> > Since we binary-patch the critical ones, this doesn't make a speed
> > impact.
> 
> This turned out really hideous looking to me.  Can't we split the struct 
> into GPL'd and non-GPL'd functions instead?  We still have the same 
> granularity, and none of this function call to an indirect function call 
> nonsense.

This patch, indeed, should not have been pushed in this series.  But not
for that reason: I actually prefer explicit exports.

KVM and lguest need more symbols, so the real patch will make them use
native_XXX versions explicitly...

Cheers,
Rusty.


