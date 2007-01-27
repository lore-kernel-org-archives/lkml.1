Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbXA0BWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbXA0BWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 20:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXA0BWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 20:22:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:44960 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751835AbXA0BWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 20:22:39 -0500
X-Authenticated: #4399952
From: Florian Schmidt <mista.tapas@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: blacklist kernel boot option
Date: Sat, 27 Jan 2007 02:22:36 +0100
User-Agent: KMail/1.9.5
X-Face: %EpW[IH18fBP*R?oz~]%Klbl.q!_(Xs_q"t?K~RVx[c7~3|C3kDdA(8y_KOB\{(Rn(MZhm
	{/l.>O48>i9k<+(,c^Y%mGm)M\+RxuxL4r<7-W63sB$+w\}hkT"Q2?v&N:y\Z
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701270222.36060.mista.tapas@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

i was wondering whether there exists any mechanism to blacklist modules from 
being loaded besides the typical /etc/modprobe.d/blacklist type mechanisms. 
Sometimes you have a module oopsing because of faulty hw which cannot be 
removed rendering the system unbootable.

And sometimes there's just no way to edit the modprobe blacklist because you 
cannot boot the box :)

Basically i would like to setup a list of module names the kernel simply 
refuses to load..

blacklist=some_module,some_other_module,some_third_module

Does something exist? Do you think it makes sense? Would it be tough to 
implement?

Regards,
Flo


-- 
Palimm Palimm!
http://tapas.affenbande.org
