Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbXHASgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbXHASgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761166AbXHASgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:36:00 -0400
Received: from ns.suse.de ([195.135.220.2]:43010 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465AbXHASf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:35:59 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] [PATCH] Deprecate a.out ELF interpreters
Date: Wed, 1 Aug 2007 20:35:52 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200708011433.09433.ak@novell.com> <Pine.LNX.4.64.0708012029130.26668@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708012029130.26668@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708012035.52863.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 August 2007 20:30:18 Jan Engelhardt wrote:
> 
> On Aug 1 2007 14:33, Andi Kleen wrote:
> >Comments?
> 
> A kconfig entry "(OBSOLETE)"/"(DEPRECATED)" would be nice.
> (And if you want to test people, 'depends on EMBEDDED' for CONFIG_BINFMT_AOUT)

The point is to have less clutter in binfmt_elf.c (which really
could need a rewrite btw or at least a lot of cleanup) not add more in form 
of ifdefs.

-Andi
