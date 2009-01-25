Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZAYGts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZAYGts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 01:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZAYGtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 01:49:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:40719 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbZAYGtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 01:49:39 -0500
Subject: Re: building custom module on 2.6.28 fails
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com>
References: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 12:19:25 +0530
Message-Id: <1232866165.3195.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-25 at 10:27 +0530, Satish Eerpini wrote:
> include/linux/mmzone.h:18:26: error: linux/bounds.h: No such file or directory
> include/linux/mmzone.h:256:5: warning: "MAX_NR_ZONES" is not defined
> In file included from include/linux/gfp.h:4,
>                  from include/linux/kmod.h:22,
>                  from include/linux/module.h:13,
>                  from /home/satish/prog/kernel/modules/simple-mod.c:1:
> include/linux/mmzone.h:277: error: 'MAX_NR_ZONES' undeclared here (not
> in a function)
> make[2]: *** [/home/satish/prog/kernel/modules/simple-mod.o] Error 1
> make[1]: *** [_module_/home/satish/prog/kernel/modules] Error 2
> make[1]: Leaving directory `/usr/src/kernels/linux-2.6.28'
> make: *** [all] Error 2
> __________________________________________________________________
> 
> any hints what could be wrong ?
> 

what is the output of:

ls -l /usr/src/kernels/linux-2.6.28/include/linux/bo*

--
JSR

