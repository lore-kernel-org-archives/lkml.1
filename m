Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZBRDgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZBRDgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZBRDfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:35:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58999
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbZBRDfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:35:22 -0500
Date: Tue, 17 Feb 2009 19:35:07 -0800 (PST)
Message-Id: <20090217.193507.08660937.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 33/43] drivers/net/tulip: fix sparse warning: symbol
 shadows an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214214707.24377.56661.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214214707.24377.56661.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:47:30 +0100

> Impact: Rename a local variable resp. remove a redundant variable and
> while being at it use more unform loop constructs.
> 
> Fix this sparse warning:
>   drivers/net/tulip/de4x5.c:3944:13: warning: symbol 'i' shadows an earlier one
>   drivers/net/tulip/de4x5.c:3938:9: originally declared here
>   drivers/net/tulip/media.c:72:21: warning: symbol 'i' shadows an earlier one
>   drivers/net/tulip/media.c:54:13: originally declared here
>   drivers/net/tulip/media.c:134:21: warning: symbol 'i' shadows an earlier one
>   drivers/net/tulip/media.c:117:13: originally declared here
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
