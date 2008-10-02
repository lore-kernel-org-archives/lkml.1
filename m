Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbYJBGFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbYJBGFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYJBGFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:05:10 -0400
Received: from zertifikatstelle.de ([87.106.91.100]:36824 "EHLO
	mail.mailbarrier.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYJBGFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:05:09 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Oct 2008 02:05:09 EDT
Message-ID: <48E46214.2090108@mailbarrier.de>
Date: Thu, 02 Oct 2008 07:54:28 +0200
From: Gregor Rebel <linux@mailbarrier.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Anybody interested in a kernel memory manager?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently writing two modules related to XEN. Both modules need to
acquire dynamic memory (via __get_free_pages() and kmalloc() ).
In order to reuse some code, I wrote a third module which can provide
simple memory-services to other modules:
* Allocated pages and memories of each client-module gets tracked
* When a module is about to exit, it can issue one function call to
release all of its memories
* Before first using the memory manager, each module has to obtain a
unique owner id number by calling a registration function
* by loading the memory manager with a debug argument, memory
allocations automatically get logged into syslog facility

I know, that currently each module keeps track of its memory allocations
on its own.

Is there a general interest to have such a memory manager in the kernel?


--
Gregor

