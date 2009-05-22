Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbZEVGbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbZEVGbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZEVGav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:30:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57172
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbZEVGau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:30:50 -0400
Date: Thu, 21 May 2009 23:30:48 -0700 (PDT)
Message-Id: <20090521.233048.263256774.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, torvalds@linux-foundation.org,
       xemul@parallels.com, orenl@cs.columbia.edu, serue@us.ibm.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 09/38] netns 1/2: don't get/put old netns on
 CLONE_NEWNET
From: David Miller <davem@davemloft.net>
In-Reply-To: <1242968132-1044-9-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
	<1242968132-1044-9-git-send-email-adobriyan@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 22 May 2009 08:55:03 +0400

> copy_net_ns() doesn't copy anything, it creates fresh netns, so get/put of old
> netns isn't needed.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Acked-by: Serge Hallyn <serue@us.ibm.com>

Acked-by: David S. Miller <davem@davemloft.net>
