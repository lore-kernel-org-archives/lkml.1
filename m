Return-Path: <linux-kernel-owner+w=401wt.eu-S1766997AbXDEOY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766997AbXDEOY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767009AbXDEOY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:24:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:57451 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766997AbXDEOY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:24:57 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86: limit mwait_idle to Intel CPUs
Date: Thu, 5 Apr 2007 16:24:45 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070405140045.GN6356@alberich.amd.com>
In-Reply-To: <20070405140045.GN6356@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704051624.45747.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 16:00:45 Andreas Herrmann wrote:
> 
> Commit 991528d7348667924176f3e29addea0675298944
> introduced mwait_idle which is supposed to work
> for Intel CPUs starting with Core Duo.
> 
> AMD Fam10 processors won't enter C1 on mwait.

Unfortunate. Will this be fixed?

> This patch will enable default_idle for non-Intel
> CPUs even if mwait is supported.

It would be better to clear MONITOR/MWAIT in the AMD specific
CPU initialize code than add workarounds everywhere else.

-Andi
