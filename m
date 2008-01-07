Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYAGQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYAGQiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbYAGQio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:38:44 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39493 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbYAGQin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:38:43 -0500
Date: Mon, 7 Jan 2008 18:38:41 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
cc: stable@kernel.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, mingo@elte.hu, torvalds@linux-foundation.org,
       clameter@sgi.com
Subject: Re: [stable] [PATCH] slub: provide /proc/slabinfo
In-Reply-To: <20080107163507.GA18981@kroah.com>
Message-ID: <Pine.LNX.4.64.0801071837410.17780@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801071426350.31604@sbz-30.cs.Helsinki.FI>
 <20080107163507.GA18981@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 7 Jan 2008, Greg KH wrote:
> This feels to me like a "feature addition", and as such, I don't think
> it is aplicable for the .23-stable tree.

It's an ABI regression (slabtop, for example, doesn't work) when 
CONFIG_SLUB is enabled.

			Pekka
