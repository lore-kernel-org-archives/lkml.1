Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXFOSB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXFOSB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXFOSBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:01:47 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:11680 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752349AbXFOSBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:01:46 -0400
Date: Fri, 15 Jun 2007 20:01:49 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paulo Marques <pmarques@grupopie.com>,
       Bernd Paysan <bernd.paysan@gmx.de>, Al Viro <viro@ftp.linux.org.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615180149.GB4952@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Paulo Marques <pmarques@grupopie.com>,
	Bernd Paysan <bernd.paysan@gmx.de>, Al Viro <viro@ftp.linux.org.uk>,
	Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <200706151014.45383.bernd.paysan@gmx.de> <46727CCF.9030905@grupopie.com> <200706151403.57178.bernd.paysan@gmx.de> <4672A231.9000800@grupopie.com> <20070615154522.2a161884@the-village.bc.nu> <d120d5000706150752n72668be2qf5b56b43cb253174@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000706150752n72668be2qf5b56b43cb253174@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This was actually a part of a larger reply - but I decided not to sent
that. Didn't want to throw away the work I did to get accurate numbers
though ;)

   I investigated:

   find -name "*.c" | wc --lines
   11100
   find -name "*.c" | xargs egrep "(version 2.*([Ll]icense|redistribute|released|GNU|GPL|any later version|Foundation))|(([Ll]icense|redistribute|released|GNU|GPL|any later version|Foundation).*version 2)" | sed -e 's/:.*//' | sort -u | wc --lines
   4042
   find -name "*.c" | xargs egrep "(version 2.*([Ll]icense|redistribute|released|GNU|GPL|any later version|Foundation))|(([Ll]icense|redistribute|released|GNU|GPL|any later version|Foundation).*version 2)" | egrep -v '(either version 2(\.[0-9])*|version 2(\.[0-9])*( of the License)*,* or)' | sed -e 's/:.*//' | sort -u | wc --lines
   1377
   find -name "*.c" | xargs egrep "(version 2.*([Ll]icense|redistribute|released|GNU|GPL|any later version|Foundation))|(([Ll]icense|redistribute|released|GNU|GPL|any later version|Foundation).*version 2)" | egrep -v '(either version 2(\.[0-9])*|version 2(\.[0-9])*( of the License)*,* or)' | sed -e 's/:.*//' | sort -u | xargs grep 'any later version' | wc --lines
   4

   Hence there are 1377 - 4 = 1373 .c files that explicitely say 'version 2',
   and 4042 - 1373 = 2669 .c files that say 'version 2 or later'.
   There are 11100 - 1373 - 2669 = 7058 files that do not say anything.

