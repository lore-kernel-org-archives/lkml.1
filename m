Return-Path: <linux-kernel-owner+w=401wt.eu-S939749AbXHINNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939749AbXHINNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938659AbXHINNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:13:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:53944 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXHINNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:13:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH] [4/12] x86_64: Disable CLFLUSH support again
Date: Thu, 9 Aug 2007 15:12:03 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070809241.425881000@suse.de> <20070809124131.B6E6114F3B@wotan.suse.de> <20070809131121.GL3311@rhun.haifa.ibm.com>
In-Reply-To: <20070809131121.GL3311@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091512.03601.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 15:11:21 Muli Ben-Yehuda wrote:

> Aside from the bug Jan pointed out with the patch, we're also using
> cflflush in other places (arch/i386/kernel/alternative.c and
> arch/x86_64/kernel/tce.c). Is the issue with clflush support specific
> to pageattr.c 

Specific to pageattr.c

-Andi
