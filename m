Return-Path: <linux-kernel-owner+w=401wt.eu-S967728AbXILMNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967728AbXILMNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966053AbXILMNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:13:40 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:41654
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764401AbXILMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:13:40 -0400
Date: Wed, 12 Sep 2007 05:13:32 -0700 (PDT)
Message-Id: <20070912.051332.85394375.davem@davemloft.net>
To: greg@kroah.com
Cc: andre@finow14.de, torvalds@osdl.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: Re: hci_sock.c build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070912120407.GB13003@kroah.com>
References: <20070912092929.GA2878@ahaupt-debian-vm.localdomain>
	<20070912120253.GA13003@kroah.com>
	<20070912120407.GB13003@kroah.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 12 Sep 2007 05:04:07 -0700

> It was 767c5eb5d35aeb85987143f0a730bc21d3ecfb3d that caused it.  It
> needs a .h file added to the file, patch forthcoming...

Ok, I though it was a CONFIG_COMPAT ifdef issue, feel
free to push the header include fix.
