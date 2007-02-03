Return-Path: <linux-kernel-owner+w=401wt.eu-S1946362AbXBCHkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946362AbXBCHkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 02:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946379AbXBCHkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 02:40:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:62998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946362AbXBCHkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 02:40:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: maynardj@us.ibm.com
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling Cell BE SPUs -- update
Date: Sat, 3 Feb 2007 08:40:05 +0100
User-Agent: KMail/1.9.5
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <45BE4ED0.5030808@us.ibm.com> <200701310752.48632.arnd@arndb.de> <45C36B21.60400@us.ibm.com>
In-Reply-To: <45C36B21.60400@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702030840.06270.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/ZRUwtOdbFtjVvewpd9tY31qBK8Bw1ugxsbSvD1FRiKna+l8fmTpweGS2R+yPFsFJmgVDvQPf0635GH+RnBPLTyqfqwlF0EEEx1Y45E2I3nw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 February 2007 17:47, Maynard Johnson wrote:
> 
> > We also want to be able to profile the context switch code itself, which
> > means that we also need one event buffer associated with the kernel to
> > collect events that for a zero context_id.
> The hardware design precludes tracing both SPU and PPU simultaneously.
> 
I mean the SPU-side part of the context switch code, which you can find
in arch/powerpc/platforms/cell/spufs/spu_{save,restore}*.

This code is the one that runs when context_id == 0 is passed to the
callback.

	Arnd <><
