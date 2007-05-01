Return-Path: <linux-kernel-owner+w=401wt.eu-S1031582AbXEAHXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031582AbXEAHXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 03:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031590AbXEAHXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 03:23:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031582AbXEAHXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 03:23:48 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] [8/30] x86_64: Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu
Date: Tue, 1 May 2007 09:23:33 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070501557.815359000@suse.de> <20070501035805.9FA9513CAF@wotan.suse.de> <4636D6E5.8090006@goop.org>
In-Reply-To: <4636D6E5.8090006@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705010923.33771.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Use linux/elfnote.h?

Good point. Will fix. I just copied it from i386, but it probably
should be there fixed too.

Actually they are not completely equivalent because the old macro
generates the section name differently from the name in the payload
(kernelversion, Linux). But I split that up into two notes now.

If that is done on i386 it might break gdb reading core files though?

BTW if anybody noticed the patch also contained a few dead hunks (two unused functions/
prototypes and some white space change). These are already gone now too.

-Andi
