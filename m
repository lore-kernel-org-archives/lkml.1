Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbYKZNHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbYKZNHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYKZNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:07:04 -0500
Received: from cet.com.ru ([195.178.208.66]:34149 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYKZNHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:07:03 -0500
Date: Wed, 26 Nov 2008 16:07:01 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Gleb Natapov <gleb@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Host<->guest channel interface advice needed
Message-ID: <20081126130701.GB8921@ioremap.net>
References: <20081126123919.GC3521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126123919.GC3521@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb.

On Wed, Nov 26, 2008 at 02:39:19PM +0200, Gleb Natapov (gleb@redhat.com) wrote:
> The interfaces that are being considered are netlink socket (only datagram
> semantics, linux specific), new socket family or character device with
> different minor number for each channel. Which one better suits for
> the purpose?  Is there other kind of interface to consider? New socket
> family looks like a good choice, but it would be nice to hear other
> opinions before starting to work on it.

What about X (or whatever else) protocol running over host-guest network
device, which are in the kernel already?

-- 
	Evgeniy Polyakov
