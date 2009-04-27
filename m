Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbZD0KWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbZD0KWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbZD0KWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:22:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45973
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbZD0KWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:22:31 -0400
Date: Mon, 27 Apr 2009 03:22:24 -0700 (PDT)
Message-Id: <20090427.032224.88109207.davem@davemloft.net>
To: simon@fire.lp0.eu
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] cxacru: Fix negative dB output
From: David Miller <davem@davemloft.net>
In-Reply-To: <49F0A306.9010409@simon.arlott.org.uk>
References: <49F0A306.9010409@simon.arlott.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Arlott <simon@fire.lp0.eu>
Date: Thu, 23 Apr 2009 18:19:02 +0100

> Values of dB between -0.99 and -0.01 will be output with the wrong
> sign. This converts the negative value to positive and outputs it
> with a "-" prefix.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

Applied to net-next-2.6, thanks.
