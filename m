Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYFSXKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYFSXKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 19:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYFSXKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 19:10:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45314
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753673AbYFSXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 19:10:05 -0400
Date: Thu, 19 Jun 2008 16:10:05 -0700 (PDT)
Message-Id: <20080619.161005.235931417.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670806190902l48c542e0i6a7380a2d3e7f520@mail.gmail.com>
References: <a4423d670806190707k7ae6da8cud80a826a1603d941@mail.gmail.com>
	<a4423d670806190902l48c542e0i6a7380a2d3e7f520@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander Beregalov" <a.beregalov@gmail.com>
Date: Thu, 19 Jun 2008 20:02:44 +0400

> I have reverted this commit and
> 2.6.26-rc6-00233-g99d3b2d works fine. It can boot.

Thanks for your report, I'll look into this.

The irony is that this changeset was added to fix a
hang with lockdep enabled :-)
