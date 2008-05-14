Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbYENEzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbYENEzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYENEzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:55:44 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:49284 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYENEzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:55:44 -0400
Message-ID: <482A70BC.3010607@t-online.de>
Date: Wed, 14 May 2008 06:55:24 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080503)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <4829326A.6060808@t-online.de> <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com> <4829D345.7020909@t-online.de> <20080513194612.GV8474@1wt.eu>
In-Reply-To: <20080513194612.GV8474@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: ZSvZnrZaQh0xMfv6oLdMryvqGNwjvGDDypijvg9yBb4O0JDiNrmcGERqjpz7lBrwWG
X-TOI-MSGID: 0886328a-cb0e-4a66-86ea-93f3da6861ed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> 
> even as root ? Because if you run strace on "su" as a user, you will
> lose the setuid which may change the conditions.
> 

It gets stuck _only_ if I am root. Running su without root permission
is no problem.

As written before, If I kick out the "stty intr '^C'" from root's
.bashrc, then the second su succeeds. Running the stty command
manually in this new shell is no problem.

Can you reproduce this problem? It doesn't need XWindow or any
special user. Simply login as root on tty2, and run "su". If it
gets stuck, then you could login on tty3 and kill -9 ### the blocking
stty.


Regards

Harri

