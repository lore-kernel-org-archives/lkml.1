Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbZBYWCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbZBYWCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZBYWBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:01:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39366
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757811AbZBYWBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:01:53 -0500
Date: Wed, 25 Feb 2009 14:01:36 -0800 (PST)
Message-Id: <20090225.140136.74121676.davem@davemloft.net>
To: ecashin@coraid.com
Cc: roel.kluin@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] aoe: error printed 1 too early
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090225170901.GA26634@coraid.com>
References: <49A549EE.7020202@gmail.com>
	<20090225170901.GA26634@coraid.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ed Cashin <ecashin@coraid.com>
Date: Wed, 25 Feb 2009 12:09:02 -0500

> Sounds like a good catch.  Did you find it because you saw the "cannot
> free skb" message?

He's finding these by looking for them in the code, not by
actually triggering the condition.
