Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbYE2VcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbYE2VcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYE2VcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:32:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50785
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbYE2VcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:32:01 -0400
Date: Thu, 29 May 2008 14:31:57 -0700 (PDT)
Message-Id: <20080529.143157.02330907.davem@davemloft.net>
To: yhlu.kernel@gmail.com
Cc: matthew@wil.cx, arjan@linux.intel.com, greg@kroah.com,
       James.Bottomley@hansenpartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
From: David Miller <davem@davemloft.net>
In-Reply-To: <86802c440805291355p5697c775k5f0beb8163688058@mail.gmail.com>
References: <483F1232.4010003@linux.intel.com>
	<20080529204736.GZ22636@parisc-linux.org>
	<86802c440805291355p5697c775k5f0beb8163688058@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Date: Thu, 29 May 2008 13:55:16 -0700

> driver should check fw version...

This alone is not a reason to rip the firmware out into a seperate
tree.  And I am absolutely not convinced that the cases where this
matters all universally even use firmware versions.

I've installed the wrong ipw2200 on several occaisions.

Furthermore, it's about distributing what works with what it's meant
to work with.  With this seperate scheme, I can still link in the
wrong firmware file (the driver doesn't check the firmware version
until it executes) and the driver won't work.  So this moves the
validation to run time, which users typically don't appreciate.

