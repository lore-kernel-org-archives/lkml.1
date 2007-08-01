Return-Path: <linux-kernel-owner+w=401wt.eu-S1762428AbXHAUNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762428AbXHAUNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXHAUNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:13:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:49602 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbXHAUNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:13:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] [PATCH] Deprecate a.out ELF interpreters
Date: Wed, 1 Aug 2007 22:13:34 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200708011433.09433.ak@novell.com> <200708012035.52863.ak@novell.com> <Pine.LNX.4.64.0708012125290.26668@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708012125290.26668@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708012213.34427.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  config BINFMT_AOUT
> -	tristate "Kernel support for a.out and ECOFF binaries"
> +	tristate "Kernel support for a.out and ECOFF binaries (OBSOLETE)"

I'm _NOT_ proposing to obsolete a.out support. Just a.out ld.so support for ELF 
executables.  The relevant code is in binfmt_elf.c

-Andi

