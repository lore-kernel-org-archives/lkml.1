Return-Path: <linux-kernel-owner+w=401wt.eu-S1762581AbYFDVze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762581AbYFDVze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYFDVzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:55:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55079
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbYFDVzX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:55:23 -0400
Date: Wed, 04 Jun 2008 14:55:22 -0700 (PDT)
Message-Id: <20080604.145522.118061703.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, rjw@sisk.pl, akpm@linux-foundation.org,
       johnpol@2ka.mipt.ru, mcmanus@ducksong.com
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
 v2.6.26-rc3+
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806042202030.6328@wrl-59.cs.helsinki.fi>
References: <20080604072311.GA32491@elte.hu>
	<20080604.112426.62778239.davem@davemloft.net>
	<Pine.LNX.4.64.0806042202030.6328@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Wed, 4 Jun 2008 23:56:34 +0300 (EEST)

> Do you know if TCP ever needs to lock the child sk again (after creating 
> it and it has started to live on its own) from a context that has already 
> locked the listen_sk (it could deadlock after this change)?

I don't know, and since I'm getting back onto an airplane again tomorrow
morning I'm the last person who is likely do be able to do an audit
of these cases for you :-)
