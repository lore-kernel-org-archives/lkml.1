Return-Path: <linux-kernel-owner+w=401wt.eu-S934040AbYEGWuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbYEGWuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbYEGWtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:49:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39797
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757294AbYEGWtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:49:45 -0400
Date: Wed, 07 May 2008 15:49:39 -0700 (PDT)
Message-Id: <20080507.154939.172601631.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18465.63175.561233.228014@alkaid.it.uu.se>
References: <18465.63175.561233.228014@alkaid.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Wed, 7 May 2008 20:36:55 +0200

> Now that 2.6.26-rc1 boots on my Ultra5, I noticed that it
> reports having only 128MB RAM, while earlier kernels reported
> the correct amount: 256MB.
> 
> A diff of the dmesg output from 2.6.25 and 2.6.26-rc1 shows:

Thanks for the report, I'll try to track this one down.

I have a machine configured similarly to your's, so this ought
to not be too difficult to fix... I hope. :-)
