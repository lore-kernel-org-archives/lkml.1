Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbZFARGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbZFARGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZFARG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:06:28 -0400
Received: from sous-sol.org ([216.99.217.87]:39979 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750842AbZFARG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:06:27 -0400
Date: Mon, 1 Jun 2009 10:06:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, chrisw@sous-sol.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 1/3] kvm: fix potential coalesced_mmio leak on
	shutdown
Message-ID: <20090601170613.GS20823@sequoia.sous-sol.org>
References: <20090601165134.18202.87598.stgit@dev.haskins.net> <20090601165445.18202.2291.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601165445.18202.2291.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:
> It would appear that we are invoking kfree() on the wrong pointer in the
> destructor for the coalesced_mmio device.  This could result in a potential
> leak during shutdown.  This works today because the kvm_io_device is
> the first element of the private structure, but this could change in
> the future, so lets clean this up.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>
