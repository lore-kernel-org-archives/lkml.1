Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbXISQxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbXISQxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXISQxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:53:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57745
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbXISQxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:53:06 -0400
Date: Wed, 19 Sep 2007 09:52:51 -0700 (PDT)
Message-Id: <20070919.095251.45154496.davem@davemloft.net>
To: drepper@redhat.com
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: follow-up: discrepancy with POSIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <46F15305.2030507@redhat.com>
References: <46F13E8B.4050309@redhat.com>
	<p73sl5aveqh.fsf@bingen.suse.de>
	<46F15305.2030507@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Wed, 19 Sep 2007 09:49:09 -0700

> But the spec calls for a "null address" to be used and that's in my
> understanding something different from using AF_UNSPEC.

It just occured to me that AF_UNSPEC might be used simply
because "all zeros" might be a valid real bindable address
for some address family.  And using AF_UNSPEC avoids that
problem entirely.
