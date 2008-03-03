Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYCCV6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYCCV6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYCCV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:58:35 -0500
Received: from mailout07.sul.t-online.de ([194.25.134.83]:52915 "EHLO
	mailout07.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbYCCV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:58:34 -0500
Message-ID: <47CC7470.5020009@t-online.de>
Date: Mon, 03 Mar 2008 22:58:08 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Mike@Keehan.net, linux-kernel@vger.kernel.org
Subject: Re: strange behavior on multimedia eject button for cdrom
References: <47C15020.8040806@t-online.de>	<47C7FECD.3040205@Keehan.net>	<47CB11FA.60008@t-online.de> <20080302125402.4af85abc@laptopd505.fenrus.org>
In-Reply-To: <20080302125402.4af85abc@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: E1C44eZ6ghPvwAoo350naxKwiCtlQ4-jdrOhKKwKgK9IseorNKaqtVsnegQDSwAwGg
X-TOI-MSGID: 7a4081c9-8bab-4ecb-b644-689ac27f08dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

Arjan van de Ven wrote:
> 
> try (temporarily) disable the hal storage polling thing.....
> that could well avoid the entire issue.
> 
> 

Now _that_ was an improvement. After hald has been stopped the problem
is gone.

Even better: Seems that hald was responsible for keeping my CD drive
spinning all the time. Since hald is gone the CD drive stops spinning
after a few seconds :-). And playing DVDs the whole system is _much_
more responsive, the DVD navigation menus are faster, etc.

Hopefully there is a configure option to tell hald to keep the CD drive
alone.


Thanx very much

Harri

