Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYBRByA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYBRByA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYBRBxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:53:51 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:2902 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYBRBxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:53:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=K3iIEeJYaIc4oqrVCq7QKAiFxCagRIa+Z7ezn+wFS7Z67/uhAgOs+Zcd38sPcdEdpMnVTi93aWs7Y+VPnBuGQ4xrzyq8vSlmSRoxN8UgDbh2bXm13+EZzqvb8JNKHSHBkvboOs+HIxLsCimuyUkHkBIENZoSK/Ma1vrBlOmHWMY=
Subject: Re: IO_DELAY documentation
From: Calvin Walton <calvin.walton@gmail.com>
To: George Spelvin <linux@horizon.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080218012103.31563.qmail@science.horizon.com>
References: <20080218012103.31563.qmail@science.horizon.com>
Content-Type: text/plain
Date: Sun, 17 Feb 2008 20:53:47 -0500
Message-Id: <1203299627.13696.26.camel@trillian>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-17 at 20:21 -0500, George Spelvin wrote:
> "make oldconfig" doesn't know how to display the per-item help, so
> something like this is needed.  It was a squeeze to make all the help
> text, plus option prompt, fit into 24 lines.  If you think that's not
> a concern, some of the wording could be improved.

It's not really well documented (I found it by accident), but you can
see the individual item help; you just need to type the choice number
followed by a question mark, like so:

Choose SLAB allocator
  1. SLAB (SLAB)
> 2. SLUB (Unqueued Allocator) (SLUB)
choice[1-2?]: 1?

The regular slab allocator that is established and known to work
well in all environments. It organizes cache hot objects in
per cpu and per node queues. SLAB is the default choice for
a slab allocator.

-- 
Calvin Walton <calvin.walton@gmail.com>


