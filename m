Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZCVAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZCVAA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZCVAAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 20:00:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35410
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbZCVAAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 20:00:02 -0400
Date: Sat, 21 Mar 2009 16:59:50 -0700 (PDT)
Message-Id: <20090321.165950.248659848.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Phonet:fix build problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090320115838.GA26371@orion>
References: <20090320115838.GA26371@orion>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Fri, 20 Mar 2009 14:58:38 +0300

> net/phonet/pep.c: In function 'pipe_rcv_status':
> net/phonet/pep.c:262: error: lvalue required as left operand of assignment
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

What platform hits this problem?

I think that platform's atomic_add() implementation should
be fixed instead.
