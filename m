Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbZEMRRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbZEMRRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 13:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760239AbZEMRRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 13:17:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40699 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760074AbZEMRQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 13:16:59 -0400
Date: Wed, 13 May 2009 10:15:19 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Marc Dionne <marc.c.dionne@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression in 2.6.30 - /dev/pts - mount options - bisected
Message-ID: <20090513171519.GA937@linux.vnet.ibm.com>
References: <6041d2000905081454x4c9d8818oaccbcd14d1f4a506@mail.gmail.com> <alpine.LRH.2.00.0905131440010.28386@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0905131440010.28386@vixen.sonytel.be>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven [Geert.Uytterhoeven@sonycom.com] wrote:

| And indeed, disabling CONFIG_DEVPTS_MULTIPLE_INSTANCES in the Fedora-based
| config makes the problem go away, and brings back my terminal-emulators.

Yes, a patch is available for this at

	http://lkml.org/lkml/2009/5/11/586

The patch has been merged into -mm.

Thanks,

Sukadev
