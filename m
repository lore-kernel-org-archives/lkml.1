Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZEWLgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZEWLgC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 07:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZEWLfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 07:35:53 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:41122 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZEWLfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 07:35:53 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: "make config" to another architecture doesn't relink include/asm
Date: Sat, 23 May 2009 06:35:50 -0500
User-Agent: KMail/1.9.9
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, sam@ravnborg.org
References: <alpine.LFD.2.00.0905221219500.13933@localhost.localdomain> <200905231322.16154.arnd@arndb.de>
In-Reply-To: <200905231322.16154.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905230635.52650.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat May 23 2009, Arnd Bergmann wrote:
> On Friday 22 May 2009, Robert P. J. Day wrote:
> >   shouldn't it be sufficient that, if i do another "make ??_defconfig"
> > to another architecture, all traces of the previous configure are
> > erased and include/asm should be relinked automatically?
> 
> In 2.6.30, the symlink is finally no longer needed, so maybe we
> should simply drop it to solve this problem as well.
>

With the note to set ARCH='<whatever>' either in the environment
or on the command line beforehand.
Sort of a "belt and suspenders" suggestion.

Mike 
> 	Arnd <><
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


