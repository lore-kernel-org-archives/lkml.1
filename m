Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZJ1MQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZJ1MQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 08:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZJ1MQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 08:16:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54249
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293AbZJ1MQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 08:16:39 -0400
Date: Wed, 28 Oct 2009 05:17:03 -0700 (PDT)
Message-Id: <20091028.051703.82082932.davem@davemloft.net>
To: arndbergmann@googlemail.com
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910281313.32827.arnd@arndb.de>
References: <20091027.230450.222178419.davem@davemloft.net>
	<20091028.005342.60092591.davem@davemloft.net>
	<200910281313.32827.arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arndbergmann@googlemail.com>
Date: Wed, 28 Oct 2009 13:13:32 +0100

> IMHO a better way to handle the radeon specific ioctls would be to
> avoid the compat_alloc_user_space and just define the common
> function taking a kernel pointer, with two implementations of the
> copy operation:

Agreed, that would be a great follow-on patch to mine.
