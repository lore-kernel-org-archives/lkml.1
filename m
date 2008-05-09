Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbYEIVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbYEIVcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYEIVcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:32:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37763
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbYEIVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:32:35 -0400
Date: Fri, 09 May 2008 14:32:29 -0700 (PDT)
Message-Id: <20080509.143229.174354251.davem@davemloft.net>
To: jesper@krogh.cc
Cc: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <482498D5.9060008@krogh.cc>
References: <86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com>
	<20080507.141521.193714938.davem@davemloft.net>
	<482498D5.9060008@krogh.cc>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Krogh <jesper@krogh.cc>
Date: Fri, 09 May 2008 20:32:53 +0200

> When it works I doesnt seem to be able to get it pass 500MB/s.

With this card you really need multiple cpus and multiple threads
sending data through the card in order to fill the 10Gb pipe.

Single connections will not fill the pipe.
