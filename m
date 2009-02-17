Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZBQWkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZBQWkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbZBQWjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:39:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59402
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753592AbZBQWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:39:52 -0500
Date: Tue, 17 Feb 2009 14:39:37 -0800 (PST)
Message-Id: <20090217.143937.29003867.davem@davemloft.net>
To: etienne.basset@numericable.fr
Cc: casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
From: David Miller <davem@davemloft.net>
In-Reply-To: <499B178B.9090601@numericable.fr>
References: <fa.HFpMNTzIQ1+pODZB3+XkfnipCfo@ifi.uio.no>
	<fa.3IBoeBnwT1eZcqeO6DAE1tHBYc4@ifi.uio.no>
	<499B178B.9090601@numericable.fr>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: etienne <etienne.basset@numericable.fr>
Date: Tue, 17 Feb 2009 21:01:15 +0100

> -               if ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
> +               if ( ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr) &&  (miap->s_addr | bestmask.s_addr) != 0  )

Please don't add all of those new spaces and please add a newline
after the "&&" so that the line of code does not exceed 80
columns.
