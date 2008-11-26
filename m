Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbYKZMjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbYKZMjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYKZMjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:39:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38336 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbYKZMjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:39:21 -0500
Date: Wed, 26 Nov 2008 14:39:19 +0200
From: Gleb Natapov <gleb@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Host<->guest channel interface advice needed
Message-ID: <20081126123919.GC3521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

 I'd like to ask what would be the best user space interface for generic
guest<->host communication channel. The channel will be used to pass
mouse events to/from a guest or by managements software to communicate
with agents running in a guests or for something similar.

The interfaces that are being considered are netlink socket (only datagram
semantics, linux specific), new socket family or character device with
different minor number for each channel. Which one better suits for
the purpose?  Is there other kind of interface to consider? New socket
family looks like a good choice, but it would be nice to hear other
opinions before starting to work on it.

Thanks,

--
			Gleb.
