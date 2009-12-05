Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbZLEXL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbZLEXL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 18:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbZLEXLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 18:11:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49508
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932351AbZLEXLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 18:11:12 -0500
Date: Sat, 05 Dec 2009 15:11:19 -0800 (PST)
Message-Id: <20091205.151119.76763870.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 17/18] sparc_brk() is not needed anymore
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1NGzzv-0008Rx-51@ZenIV.linux.org.uk>
References: <E1NGzzv-0008Rx-51@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 05 Dec 2009 19:08:51 +0000

> 
> the checks it's doing are duplicated in sys_brk() and failing
> them early makes no sense, AFAICT.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: David S. Miller <davem@davemloft.net>
