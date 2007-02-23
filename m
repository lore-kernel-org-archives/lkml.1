Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbXBWTBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbXBWTBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 14:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933176AbXBWTBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 14:01:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44007 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbXBWTBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 14:01:32 -0500
Subject: Re: irq balancing question
From: Arjan van de Ven <arjan@infradead.org>
To: Gergely Imre <imre.gergely@astral.ro>
Cc: linux-kernel@vger.kernel.org, hancockr@shaw.ca
In-Reply-To: <45DF3795.3040005@astral.ro>
References: <45DED0D6.1040700@astral.ro>
	 <1172241917.3241.4.camel@laptopd505.fenrus.org>
	 <45DF012D.3080802@astral.ro>
	 <1172246085.3241.24.camel@laptopd505.fenrus.org>
	 <45DF3795.3040005@astral.ro>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 23 Feb 2007 20:01:29 +0100
Message-Id: <1172257289.3241.48.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> and i guess it doesn't matter if the distribution is being done by the
> hardware, from the point of view of the kernel, i would still get the
> performance penalty.

for the cache bouncing you save assuming you have an Intel cpu (eg one
where the cache is shared). You don't save on the cross-cpu reassembly,
that is an entire different algorithm path you hit there..



> i'm just trying to figure it out, i have no real knowledge of the inner
> kernel workings, so i dont know. but i really would like to use all 4 cores.
> just how expensive is that reassembly path ?

depends on your traffic to be honest, probably a question more suited
for net-dev list.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

