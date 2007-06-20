Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbXFTM2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbXFTM2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbXFTM15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:27:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:36593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbXFTM14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:27:56 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [patches] [PATCH for 2.6.22] [9/10] i386: Disable alternative()patching after boot with DEBUG_RO
Date: Wed, 20 Jun 2007 14:27:38 +0200
User-Agent: KMail/1.9.6
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, patches@x86-64.org
References: <200706201223.443613000@suse.de> <20070620102338.18BF914AD0@wotan.suse.de> <467931E0.76E4.0078.0@novell.com>
In-Reply-To: <467931E0.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201427.38723.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

		return;
> 
> Why would we need this? mark_rodata_ro() already accounts for the
> CONFIG_HOTPLUG_CPU case in that it doesn't write protect .text then.

True, I missed that. The other code could be removed or this patch be
dropped.

-Andi
