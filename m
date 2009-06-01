Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbZFARGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbZFARGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZFARGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:06:42 -0400
Received: from sous-sol.org ([216.99.217.87]:39981 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751148AbZFARGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:06:41 -0400
Date: Mon, 1 Jun 2009 10:06:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, chrisw@sous-sol.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 2/3] kvm: cleanup io_device code
Message-ID: <20090601170627.GT20823@sequoia.sous-sol.org>
References: <20090601165134.18202.87598.stgit@dev.haskins.net> <20090601165450.18202.70520.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601165450.18202.70520.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:
> We modernize the io_device code so that we use container_of() instead of
> dev->private, and move the vtable to a separate ops structure
> (theoretically allows better caching for multiple instances of the same
> ops structure)
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>
