Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0CDCqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:46:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0CDCqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:46:04 -0500
Date: Thu, 4 Mar 2010 08:14:27 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>, benh@kernel.crashing.org
Subject: Re: [PATCH v2] hvc_console: Fix race between hvc_close and
	hvc_remove
Message-ID: <20100304024427.GB31594@amit-x200.redhat.com>
References: <1267630188-30824-1-git-send-email-amit.shah@redhat.com> <20100303155522.6d6a4562@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303155522.6d6a4562@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) Mar 03 2010 [15:55:22], Alan Cox wrote:
> On Wed,  3 Mar 2010 20:59:48 +0530
> Amit Shah <amit.shah@redhat.com> wrote:
> 
> > Alan pointed out a race in the code where hvc_remove is invoked. The
> > recent virtio_console work is the first user of hvc_remove().
> 
> Looks better to me.

Thanks, Alan.

Ben, can you pick this up via your tree if it looks good to you?

		Amit
