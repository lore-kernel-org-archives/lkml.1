Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbYBYUBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbYBYUBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbYBYUB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:01:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57328
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756518AbYBYUB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:01:27 -0500
Date: Mon, 25 Feb 2008 12:02:10 -0800 (PST)
Message-Id: <20080225.120210.251366287.davem@davemloft.net>
To: Steve.Hawkes@motorola.com
Cc: joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: printk_ratelimit and net_ratelimit conflict and tunable
 behavior
From: David Miller <davem@davemloft.net>
In-Reply-To: <7BFDACCD6948EF4D8FE8F4888A91596A016371FA@tx14exm60.ds.mot.com>
References: <20080220.223219.165157596.davem@davemloft.net>
	<1203577246.7181.241.camel@localhost>
	<7BFDACCD6948EF4D8FE8F4888A91596A016371FA@tx14exm60.ds.mot.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Hawkes Steve-FSH016" <Steve.Hawkes@motorola.com>
Date: Mon, 25 Feb 2008 09:47:11 -0600

> > .facility = NULL
> 
> How about this?

Actually, for compile time initializations, setting
anything to zero is superfluous and by convention
is not therefore explicitly done in the sources.
