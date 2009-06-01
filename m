Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZFARMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZFARMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZFARMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:12:37 -0400
Received: from sous-sol.org ([216.99.217.87]:57037 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751670AbZFARMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:12:36 -0400
Date: Mon, 1 Jun 2009 10:12:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, chrisw@sous-sol.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 3/3] kvm: do not register i8254 PIO regions
	until we are initialized
Message-ID: <20090601171223.GU20823@sequoia.sous-sol.org>
References: <20090601165134.18202.87598.stgit@dev.haskins.net> <20090601165455.18202.26323.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601165455.18202.26323.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:
> We currently publish the i8254 resources to the pio_bus before the devices
> are fully initialized.  Since we hold the pit_lock, its probably not
> a real issue.  But lets clean this up anyway.
> 
> Found-by: Avi Kivity <avi@redhat.com>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>
