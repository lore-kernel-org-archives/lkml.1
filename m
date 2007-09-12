Return-Path: <linux-kernel-owner+w=401wt.eu-S967901AbXILMOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967901AbXILMOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967827AbXILMOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:14:17 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:41660
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S967820AbXILMOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:14:16 -0400
Date: Wed, 12 Sep 2007 05:14:05 -0700 (PDT)
Message-Id: <20070912.051405.39173844.davem@davemloft.net>
To: greg@kroah.com
Cc: andre@finow14.de, torvalds@osdl.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: Re: hci_sock.c build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070912120726.GA13170@kroah.com>
References: <20070912120253.GA13003@kroah.com>
	<20070912120407.GB13003@kroah.com>
	<20070912120726.GA13170@kroah.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 12 Sep 2007 05:07:26 -0700

> No, this is worse, i386 doesn't have a compat_timeval structure defined,
> nor does any other 32 bit platform.
> 
> Marcel, I think you need to use a different structure, care to fix this
> up?

Ok, then see the patch I posted which will do the trick.

I'll push it around.
