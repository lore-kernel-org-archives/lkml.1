Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbZCSUcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbZCSUcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbZCSUcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:32:23 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:52800 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbZCSUcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:32:22 -0400
Subject: Re: linux-2.6 install errors due to incompatible depmod files [was
	Re: Bug#518412: initramfs-tools: must support relative paths in modules.dep
	]
From: Jon Masters <jonathan@jonmasters.org>
To: maximilian attems <max@stro.at>
Cc: Frans Pop <elendil@planet.nl>, 518412@bugs.debian.org, md@linux.it,
       Jon Masters <jcm@jonmasters.org>, linux-kernel@vger.kernel.org,
       linux-modules <linux-modules@vger.kernel.org>
In-Reply-To: <20090319201310.GI3901@baikonur.stro.at>
References: <20090319153604.GB7954@stro.at>
	 <200903191843.28437.elendil@planet.nl>
	 <20090319181031.GH3901@baikonur.stro.at>
	 <200903191940.47726.elendil@planet.nl>
	 <20090319201310.GI3901@baikonur.stro.at>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 19 Mar 2009 16:30:30 -0400
Message-Id: <1237494630.31294.31.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 21:13 +0100, maximilian attems wrote:
> [ adding jcm and lkml to Cc: ]

[ You want linux-modules@vger.kernel.org rather than LKML. I've added
the former to the CC list, we can kill LKML off the CC shortly. ]

> > That would mean that m-i-t has created a backwards incompatibility problem 
> > _with itself_ and that the problem actually is "installing a kernel, that 
> > was built on a system with new m-i-t, on a system with old m-i-t".

Looks like the problem is actually that depmod was run under the newer
version and then you tried to use the generated files with an older
modprobe. I'm not sure that's actually an error - it was noted that the
slight format change was unideal for such unlikely cases and in fact we
won't do that again in the future. But if you were just moving forwards
from one release to the next you would have been fine - you're talking
lack of forward compatibility actually.

Unless I'm missing something, in which case please clarify. I would like
it also if you'd send me the generated files, distro info, etc.

Jon.


