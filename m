Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbXKBMGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbXKBMGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 08:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXKBMGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 08:06:03 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:55405 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbXKBMGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 08:06:01 -0400
Date: Fri, 02 Nov 2007 13:05:59 +0100
Message-Id: <2061698400@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: 12o3l@tiscali.nl, jdike@addtoit.com
Subject: Re: build failure, missing libvdeplug.h?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18guLfjbyi3KpkI8XIwC9tJj5ztp2fILWsStyXmfaRHicw5w
 u4J6ssPSbpk50tdH1jc9Alk4z8E+NpEMuu/vzs/5LLmEt38WCg=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I tried 2.6.24-rc1-git11 with "allmodconfig ARCH=um" today.

this gave at least two errors - i needed to set CONFIG_SMP=n and CONFIG_UML_NET_VDE=n to make it compile.

not sure if options should be set to "n" automatically or being fixed differently, but if there is something broken or some header file missing,  from an "end-user`s" point of view errors like this may be hard to get around.

it`s nothing against UML, it`s just the fact that i would expect "allmodconfig" or "allyesconfig" to work out of the box.
one should be able to compile a kernel without the need to use google, imho.

many automated cross-compile tests i have seen till now mostly show more broken than successful builds, as you can see at http://l4x.org/k , and issues like this don`t help making this better.

minor issue, though......

regards
roland






On Mon, Oct 29, 2007 at 04:24:54PM +0100, Roel Kluin wrote:
> CC      arch/um/drivers/vde_user.o
> /home/roel/dnld/src/kernel/git/linux-2.6/arch/um/drivers/vde_user.c:8:24: error: \
>                 libvdeplug.h: No such file or directory
> /home/roel/dnld/src/kernel/git/linux-2.6/arch/um/drivers/vde_user.c: In function \
>                 'vde_user_init':
> /home/roel/dnld/src/kernel/git/linux-2.6/arch/um/drivers/vde_user.c:18: error: \
>                 'VDECONN' undeclared (first use in this function)
> ...
> 
> the file libvdeplug.h is missing and I can't find it neither in the tree or on
> the net. 'git-grep VDECONN' shows that VDECONN isn't defined anywhere.

This is an option which requires support on the host (in the form of
vde being installed - pcap is another example of this).

				Jeff



> Roel Kluin wrote:
>> the file libvdeplug.h is missing
> 
>> There is a reference to http://wiki.virtualsquare.org/index.php/Main_Page in
>> the Kconfig (also added by this commit).
>> After reverting this commit the build continues. possibly the header 
>> libvdeplug.h was forgotten?
> 
> Sorry for answering myself, but apparently it can be found here:
> 
> http://vde.sourceforge.net/
> 
> I think, however that there is a 'depends on' missing in kconfig - to prevent build
> failure?


______________________________________________________________________
XXL-Speicher, PC-Virenschutz, Spartarife & mehr: Nur im WEB.DE Club!		
Jetzt testen! http://produkte.web.de/club/?mc=021130

