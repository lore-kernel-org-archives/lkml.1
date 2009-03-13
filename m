Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbZCMV1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbZCMV1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbZCMV1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:27:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52142
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754433AbZCMV1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:27:32 -0400
Date: Fri, 13 Mar 2009 14:27:18 -0700 (PDT)
Message-Id: <20090313.142718.21189207.davem@davemloft.net>
To: scott@canonical.com
Cc: linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org
Subject: Re: [PATCH 01/31] bridge: Auto-load bridge module when socket
 opened.
From: David Miller <davem@davemloft.net>
In-Reply-To: <74b87ec3359e6e65d59cd6fb62a83fb469e6c8ae.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
	<74b87ec3359e6e65d59cd6fb62a83fb469e6c8ae.1236702228.git.scott@canonical.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 16:40:10 +0000

> The bridge module is missing the net-pf-7 alias that would cause it to
> be auto-loaded when a socket of that type is opened.  This patch adds
> the alias.
> 
> Signed-off-by: Scott James Remnant <scott@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Bridging has no sockets, so this patch won't do anything.

Did you verify that these changes actually do something?
Or did you blindly run around peppering source files with
these annotations?
