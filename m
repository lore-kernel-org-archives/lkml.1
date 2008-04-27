Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYD0Fym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYD0Fym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYD0Fyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:54:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59006
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYD0Fyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:54:33 -0400
Date: Sat, 26 Apr 2008 22:54:32 -0700 (PDT)
Message-Id: <20080426.225432.128575953.davem@davemloft.net>
To: samuel.thibault@ens-lyon.org
Cc: mtk.manpages@gmail.com, mtk.manpages@googlemail.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080426014445.GD4792@implementation>
References: <20080424001656.GM4825@implementation>
	<517f3f820804240131v3466713bi70d0eb0fb1f5cd8d@mail.gmail.com>
	<20080426014445.GD4792@implementation>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date: Sat, 26 Apr 2008 02:44:45 +0100

> AF_UNIX: make unix_getname use sizeof(sunaddr->sun_family) instead of
> sizeof(short).
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

This is just syntactic masterbation, sa_family_t is typedef'd
"unsigned short".

No system on planet earth providing the BSD sockets API uses
anything other than uint16_t or unsigned short for this.

Sorry, I'm not applying this.
