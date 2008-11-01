Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYKAMfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYKAMfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 08:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYKAMff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 08:35:35 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3892 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYKAMfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 08:35:34 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Nov 2008 08:35:34 EDT
Message-ID: <490C4B3D.9070309@xs4all.nl>
Date: Sat, 01 Nov 2008 13:27:41 +0100
From: Hans de Bruin <bruinjm@xs4all.nl>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.8-rc2 build problem
References: <490B8D5E.2050100@xs4all.nl>
In-Reply-To: <490B8D5E.2050100@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans de Bruin wrote:
> 2.6.8-rc2 won't do a make (silent)oldconfig. To make sure i did not lose 
> anything I recloned linux-2.6
> 
> commit 721d5dfe7e516954c501d5e9d0dfab379cf4241a
> 
> $ make O=/var/diskless/kernel/psion/ oldconfig
>   GEN     /var/diskless/kernel/psion/Makefile
>   HOSTCC  scripts/kconfig/zconf.tab.o
> gcc: /var/diskless/kernel/linux-2.6/scripts/kconfig/zconf.tab.c: No such 
> file or directory
> gcc: no input files
> make[2]: *** [scripts/kconfig/zconf.tab.o] Error 1
> make[1]: *** [oldconfig] Error 2
> make: *** [sub-make] Error 2
> 
> 

next time i will remember to use make O=.... mrproper

-- 
Hans
