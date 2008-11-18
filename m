Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYKRQ3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYKRQ3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYKRQ3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:29:33 -0500
Received: from main.gmane.org ([80.91.229.2]:51403 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYKRQ3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:29:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Developing non-commercial drivers ?
Date: Tue, 18 Nov 2008 10:29:14 -0600
Message-ID: <4922ED5A.3030808@shaw.ca>
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
In-Reply-To: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fredrik Markström wrote:
> Linus, others...
> 
> I'm working for as a consultant for a large hardware company porting
> Linux to their new cpu-architecture and everything is pretty much
> up and running. Now they want us to develop a closed-source (to
> protect their IP) ethernet driver for their proprietary Ethernet MAC.
> 
> My question is:    Is there a fair way to do this and still comply to
> the intent and spirit of the Linux licensing ?
> 
> If yes, how ?

In a word, I would say: no.

When developing a non-GPL kernel driver, one finds themselves on very 
shaky legal ground. Unless one is 100% sure their code is not legally 
considered a derived work from the kernel, it's likely a GPL violation.

One could point out the pile of other Ethernet drivers in the kernel 
from the likes of Intel, Broadcom, etc. and ask why those companies did 
not feel the need to "protect their IP" in this manner.. as well as the 
significant advantages of having their driver in the mainline kernel, 
and the horrible disadvantages of trying to manage closed-source drivers..

