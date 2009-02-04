Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZBDPbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZBDPbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZBDPb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:31:29 -0500
Received: from mx1.suse.de ([195.135.220.2]:59987 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbZBDPb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:31:28 -0500
Message-ID: <4989B4BF.6060509@suse.de>
Date: Wed, 04 Feb 2009 16:31:11 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       len.brown@intel.com, shaohuhua.li@intel.com,
       kristen.c.accardi@intel.com, frank@f-seidel.de
Subject: Re: [PATCH] ACPI: add missing KERN_* constants to printks
References: <4989A784.3030604@suse.de> <200902041628.03675.elendil@planet.nl>
In-Reply-To: <200902041628.03675.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> This patch looks broken to me, at least for some of your changes.
> For example, in the bit quoted above all printks together make up
> *one single* message, which means that only the _first_ of the
> printks should have the KERN_* prefix. printks that are continuations
> should not have the prefix.

Are you absolutely sure about that? The janitors todo lets me guess
they should aswell me prefixed.
Otherwise yes, then some of the changes wouldn't be needed.

Thanks,
Frank
