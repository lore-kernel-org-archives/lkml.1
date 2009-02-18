Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbZBRWGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbZBRWGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZBRWFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:05:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50982
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752815AbZBRWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:05:52 -0500
Date: Wed, 18 Feb 2009 14:05:37 -0800 (PST)
Message-Id: <20090218.140537.264263006.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Only use DRM_IOCTL_UPDATE_DRAW compat wrapper for
 compat X86.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1234994390.14060.463.camel@pasglop>
References: <20090218.013521.97380943.davem@davemloft.net>
	<1234994390.14060.463.camel@pasglop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 19 Feb 2009 08:59:50 +1100

> Could that be related to the kernel spewing a bunch of
> 
> [drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace

Yep, that is exactly caused by this bug.
