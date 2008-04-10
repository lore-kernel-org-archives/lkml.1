Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYDJI57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYDJI57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYDJI5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:57:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41065
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbYDJI5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:57:48 -0400
Date: Thu, 10 Apr 2008 01:57:47 -0700 (PDT)
Message-Id: <20080410.015747.65169066.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, lksctp-developers@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] SCTP: fix wrong debug counting of datamsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <47F1AEDB.1080300@cn.fujitsu.com>
References: <47F1AEDB.1080300@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Tue, 01 Apr 2008 11:41:15 +0800

> Should not count it if the allocation of this object
> failed.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

This is a bug fix, but for a debugging feature, so I
have applied it to net-2.6.26
