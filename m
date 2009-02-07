Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZBGTzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZBGTzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 14:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZBGTz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 14:55:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:54064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZBGTzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 14:55:25 -0500
Date: Sat, 7 Feb 2009 11:55:45 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cpu frequency maximized even for a niced job w/ v2.6.29-rc3
Message-ID: <20090207115545.724911be@infradead.org>
In-Reply-To: <200902071130.10463.toralf.foerster@gmx.de>
References: <200902071130.10463.toralf.foerster@gmx.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 11:30:10 +0100
Toralf Förster <toralf.foerster@gmx.de> wrote:

> I'm wondering, why my ThinkPad T41 goes from 600 MHz to 1.7 GHz if I
> run this job :
> 
> $> while [[ true ]]; do nice -3 factor 273244676154386297; done
> 
> under v2.6.29-rc3-562-geda58a8.
> 
> Former version stays at min frequency (600 MHz).

The kernel has defaulted to this for I think a really long time;
maybe your "former version" was a distribution kernel with patches?

Either way this is a simple tunable in sysfs; and to be honest,
going to the full speed is very often the right behavior so as a
default it is quite sane...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
