Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0BVGVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 01:21:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45710
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204Ab0BVGVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 01:21:07 -0500
Date: Sun, 21 Feb 2010 22:21:22 -0800 (PST)
Message-Id: <20100221.222122.193722153.davem@davemloft.net>
To: weigelt@metux.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dynamic linking in the kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B82197F.4050902@metux.de>
References: <4B802870.5030201@metux.de>
	<20100220.125758.174837163.davem@davemloft.net>
	<4B82197F.4050902@metux.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Enrico Weigelt <weigelt@metux.de>
Date: Mon, 22 Feb 2010 06:43:27 +0100

> David Miller wrote:
> 
>> In order to implement this the kernel would have to also save a copy
>> of all pieces of the processes's environment and compare all of the
>> environment variable settings on every execution.  This would be
>> needed to handle things like LD_PRELOAD, LD_LIBRARY_PATH, and LD_DEBUG
>> as just three examples.
> 
> Fairly simple:
> 
> * parsed per-module data is cached by its inode id
> * cached data that can be influenced by LD_PRELOAD/LD_LIBRARY_PATH
>   (eg. mapping of library names to actual filenames or inode-id's)
>   is cached on hash of these variables plus inode-id

Feel free to implement this and show us the numbers.

I am not as confident as you :-)
