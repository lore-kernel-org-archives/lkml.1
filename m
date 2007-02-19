Return-Path: <linux-kernel-owner+w=401wt.eu-S932657AbXBSV33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbXBSV33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932706AbXBSV33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:29:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:36773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657AbXBSV32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:29:28 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] [PATCH 1/3] x86_64: additions to the i386 alternative extensions to support x86_64 architecture
Date: Mon, 19 Feb 2007 22:29:22 +0100
User-Agent: KMail/1.9.5
Cc: "Joerg Roedel" <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
References: <20070219190132.GA6083@amd.com> <20070219190709.GC6083@amd.com>
In-Reply-To: <20070219190709.GC6083@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702192229.22217.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 February 2007 20:07, Joerg Roedel wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
> 
> This patch adds the necessary changes to extend the i386 alternative
> instruction framework extension on the x86_64 architecture.

Looks complicated and somewhat fragile.

I think I would prefer it if you changed the pad field to a "bit not set"
cpuid field. Then at least 2 alternatives + a nothing alternative could
be described too.

-Andi
