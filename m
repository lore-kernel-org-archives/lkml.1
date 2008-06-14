Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYFNENk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYFNENk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 00:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYFNENa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 00:13:30 -0400
Received: from ozlabs.org ([203.10.76.45]:60676 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYFNEN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 00:13:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 2/2] virtio: Complete feature negotation before updating status
Date: Sat, 14 Jun 2008 14:13:08 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <1213361201-10854-1-git-send-email-markmc@redhat.com> <1213361201-10854-2-git-send-email-markmc@redhat.com>
In-Reply-To: <1213361201-10854-2-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806141413.09036.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008 22:46:41 Mark McLoughlin wrote:
> lguest (in rusty's use-tun-ringfd patch) assumes that the
> guest has updated its feature bits before setting its status
> to VIRTIO_CONFIG_S_DRIVER_OK.
>
> That's pretty reasonable, so let's make it so.

Applied.  That's a bug, I'll send to Linus immediately (I screwed up in the 
feature changes which are new in this kernel).

Thanks for catching this,
Rusty.
