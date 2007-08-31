Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbXHaUu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbXHaUu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760909AbXHaUuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:50:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33719 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064AbXHaUuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:50:52 -0400
Date: Fri, 31 Aug 2007 22:50:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Valdis.Kletnieks@vt.edu
cc: Adrian Bunk <bunk@kernel.org>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org
Subject: Re: possible build system oddity
In-Reply-To: <26547.1188572427@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0708312250130.9413@fbirervta.pbzchgretzou.qr>
References: <200708311037.29280.oliver@neukum.org>           
 <20070831084229.GE9260@stusta.de> <26547.1188572427@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 31 2007 11:00, Valdis.Kletnieks@vt.edu wrote:
>> 
>> It seems you are confused by the fact that this recompilation results in 
>> several relinks (LD)?
>
>Or something else changed that he didn't realize.  Just the other day, I
>applied a one-line patch that hit one .c file, and *the entire kernel*
>started rebuilding.
>
>Took me a while to figure out that I'd been looking for something else, and
>done a 'vi Makefile' in the top level, and exited with 'ZZ' rather than ':q' ;)

Changing the top makefile (where your version info is) should only 
result in rebuilding the .mod.c, .mod.o and .ko files.


	Jan
-- 
