Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbZHCUUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbZHCUUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZHCUUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:20:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43888
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbZHCUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:20:40 -0400
Date: Mon, 03 Aug 2009 13:20:49 -0700 (PDT)
Message-Id: <20090803.132049.77191266.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: atl1c: Do not call cancel_work_sync from the work itself
From: David Miller <davem@davemloft.net>
In-Reply-To: <12492775393830-git-send-email-jie.yang@atheros.com>
References: <12492775393830-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Mon, 3 Aug 2009 13:32:19 +0800

> Signed-off-by: jie yang <jie.yang>@atheros.com

Your entire email address should be surrounded by '<' and '>'
characters, not just your username, in the signoff.

Also, please provide a more detailed commit message.  Explain what
goes wrong in the current code (when happens when a work is cancelled
within itself, I was under the impression that this works just fine
and is just a NOP), and the basic description of your solution.
