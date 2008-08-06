Return-Path: <linux-kernel-owner+w=401wt.eu-S1765048AbYHFMXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765048AbYHFMXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbYHFMXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:23:06 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38069 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYHFMXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:23:05 -0400
Date: Wed, 6 Aug 2008 14:23:01 +0200
From: Olaf Hering <olaf@aepfle.de>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Subject: unconditional link object arch/powerpc/lib/crtsavres.o breaks
	module build
Message-ID: <20080806122301.GA27495@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sam,

please have a look at bug 11143.
http://bugzilla.kernel.org/show_bug.cgi?id=11143


arch/powerpc/lib/crtsavres.o is added inconditionally to the linker
flags, but there is no rule to actually create the object file.
This breaks building external modules on 32bit powerpc since 2.6.26.

Thanks,
Olaf
