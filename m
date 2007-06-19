Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbXFSTDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbXFSTDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763730AbXFSTC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:02:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58746 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595AbXFSTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:02:55 -0400
Date: Tue, 19 Jun 2007 21:02:53 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: 2.6.22: ERROR: "__ucmpdi2" [drivers/net/s2io.ko] undefined!
Message-ID: <20070619190253.GA19419@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


What happend to __ucmpdi2 from David Woodhouse?
google has a few hits about stuff like this on 32bit powerpc with gcc 4.1.2:

ERROR: "__ucmpdi2" [drivers/net/s2io.ko] undefined!

using the drivers/net/s2io* files from 2.6.21 with 2.6.22-rc5 fixes the
compile.

25805dcf9d83098cf5492117ad2669cd14cc9b24 adds two u64 >>= 48 followed by
a switch statement (line 2889 and 6816).
