Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbYBOMso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbYBOMso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbYBOMsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:48:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:56059 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753970AbYBOMsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:48:31 -0500
Date: Fri, 15 Feb 2008 13:48:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Julia Lawall <julia@diku.dk>
cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/6] drivers/hid: Use DIV_ROUND_UP
In-Reply-To: <Pine.LNX.4.58.0802141616120.1185@pc-041.diku.dk>
Message-ID: <Pine.LNX.4.64.0802151347480.30955@jikos.suse.cz>
References: <Pine.LNX.4.58.0802141616120.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Julia Lawall wrote:

> -			padlen = (len + maxpacket - 1) / maxpacket;
> +			padlen = DIV_ROUND_UP(len, maxpacket);

Applied, thanks.

-- 
Jiri Kosina
