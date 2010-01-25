Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583Ab0AYGgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0AYGgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 01:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829Ab0AYGga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 01:36:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33647
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437Ab0AYGg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 01:36:29 -0500
Date: Sun, 24 Jan 2010 22:36:40 -0800 (PST)
Message-Id: <20100124.223640.119299590.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: rjw@sisk.pl, tino.keitel@gmx.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: revert config space change
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100124204606.2760d34e@nehalam>
References: <20100119193745.GA5797@x61.home>
	<201001242135.29309.rjw@sisk.pl>
	<20100124204606.2760d34e@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Sun, 24 Jan 2010 20:46:06 -0800

> Obviously, this register had some other impact that is causing
> the regression.  Either it is masking some other access or needs
> to be reset in some path.
> 
> Either, way it is best to just revert the change for 2.6.33
> 
> 
> This reverts commit 166a0fd4c788ec7f10ca8194ec6d526afa12db75.

I'll apply this, thanks Stephen.
