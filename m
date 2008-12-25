Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbYLYOkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbYLYOkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYLYOkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:40:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:54595 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYLYOkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sRhYte1xcEBMStobCLd528dM6rjtxI7DY5z7cvI5uiUNE7n5VN1XOD6yRx+7oM2Ecy
         cdlxwmR6/NJpFKld0fvwNGZGUaPC3QH5amGhPNbcd3xUZjJz4CvF2DJdcnlFuI7MWARw
         1VoUUUqfI4dP4b6RFX6bmaDaEklTDnLXM4zig=
Message-ID: <81b0412b0812250640t5d6180dct31d8cd941e06ef50@mail.gmail.com>
Date: Thu, 25 Dec 2008 15:40:39 +0100
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>, "Reinette Chatre" <reinette.chatre@intel.com>,
       linville@tuxdriver.com, ipw3945-devel@lists.sourceforge.net,
       "Jim Paris" <jim@jtan.com>
Subject: Re: Happy v2.6.28
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812241540170.3535@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0812241540170.3535@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iwl3945 is still broken as described in

  http://bugzilla.kernel.org/show_bug.cgi?id=11326

It is actually quite annoying, as it prevents shutdown when crashed.
The bug discussion mentions a fix (which looks like a workaround,
because there is still a scary message in the log). But at least
the system can be safely shut down.
