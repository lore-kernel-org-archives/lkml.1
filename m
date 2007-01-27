Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbXA0Sbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbXA0Sbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXA0Sbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:31:41 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:49000 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXA0Sbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:31:40 -0500
Date: Sat, 27 Jan 2007 19:30:48 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: External module Makefile with generated C file
In-Reply-To: <45BB96B4.30907@redhat.com>
Message-ID: <Pine.LNX.4.61.0701271929220.22295@yvahk01.tjqt.qr>
References: <45BB96B4.30907@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> ctracer_methods.o: ctracer_methods.c

$(obj)/ctracer_methods.o: $(src)/ctracer_methods.c

$(src)/ctracer_methods.c:
  ...



I don't know if $(obj) or $(src) is the right thing, but something along
these lines is required for OOT.

	-`J'
-- 
