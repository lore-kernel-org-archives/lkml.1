Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZEPHKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZEPHKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 03:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZEPHK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 03:10:28 -0400
Received: from michaelblizek.twilightparadox.com ([193.238.157.55]:50646 "EHLO
	michaelblizek.twilightparadox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbZEPHK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 03:10:27 -0400
X-Greylist: delayed 2927 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 May 2009 03:10:27 EDT
Date: Sat, 16 May 2009 08:21:37 +0200
From: Michael Blizek <michi1@michaelblizek.twilightparadox.com>
To: sikandar shah <sazamsk@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Subject: Re: how to access a sound card in linux using nasm in pure
	assembly language
Message-ID: <20090516062137.GA6036@grml>
References: <139247610905131345o5a6b291ex1b2dc9b55b6c644a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <139247610905131345o5a6b291ex1b2dc9b55b6c644a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 02:45 Thu 14 May     , sikandar shah wrote:
> Hello i am a interested in linux development,but there are many resources
> about development in C,C++ in linux but i want to do programming in
> assembly.
> 
> i am using ubuntu 8.0.2 and i want to do some task for which i cant get help
> anywhere
> 
> well i have got this assignment to access sound card or pc speaker in
> assembly using nasm and on linux operating system.
> 
> till now i have got to the point that we use interupt 0x80 for kernel calls.
> but what do we do next.
> also well i found out while searching the net that the calls are associated
> with eax
> and the argument can be upto 5 stored in ebx,ecx,edx,esi,edi

There is a simple low level api you can use which does not rely on user space
libraries:
http://manuals.opensound.com/developer/

...
> 4. how can i make it play something even the system beep

printf("\a");

	-Michi
-- 
programing a layer 3+4 network protocol for mesh networks
see http://michaelblizek.twilightparadox.com

