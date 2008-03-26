Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYCZEgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYCZEgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 00:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYCZEgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 00:36:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39544
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbYCZEgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 00:36:09 -0400
Date: Tue, 25 Mar 2008 21:36:02 -0700 (PDT)
Message-Id: <20080325.213602.193698359.davem@davemloft.net>
To: jsm@fc.hp.com
Cc: linux-ia64@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <47E9CE00.7060106@fc.hp.com>
References: <ed5aea430803251734u70f199w10951bc4f0db6262@mail.gmail.com>
	<87lk465mks.wl%peter@chubb.wattle.id.au>
	<47E9CE00.7060106@fc.hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Marvin <jsm@fc.hp.com>
Date: Tue, 25 Mar 2008 22:16:00 -0600

> 1) There was no easy way of determining what size the long format vhpt cache 
> should be automatically, and changing it dynamically would be too painful. 
> Different workloads performed better with different size vhpt caches.

This is exactly what sparc64 does btw, dynamic TLB miss hash table
sizing based upon task RSS
