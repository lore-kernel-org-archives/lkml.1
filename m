Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYAHGjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYAHGjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYAHGi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:38:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35580
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753882AbYAHGiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:38:55 -0500
Date: Mon, 07 Jan 2008 22:38:54 -0800 (PST)
Message-Id: <20080107.223854.225989700.davem@davemloft.net>
To: julia@diku.dk
Cc: marcel@holtmann.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] /net/bluetooth: Use sockfd_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0801061650370.24950@ask.diku.dk>
References: <Pine.LNX.4.64.0801061650370.24950@ask.diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 6 Jan 2008 16:51:45 +0100 (CET)

> The function sockfd_lookup uses fget on the value that is stored in the
> file field of the returned structure, so fput should ultimately be applied
> to this value.  This can be done directly, but it seems better to use the
> specific macro sockfd_put, which does the same thing.

Applied to net-2.6.25, thanks.
