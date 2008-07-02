Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbYGBIXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbYGBIXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYGBIXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:23:18 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:31637 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752627AbYGBIXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:23:17 -0400
Date: Wed, 2 Jul 2008 17:20:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [-mmotm] some different buliding failures
Message-ID: <20080702082021.GA1327@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
	Ben Dooks <ben-linux@fluff.org>
References: <486B1EE0.9060303@cn.fujitsu.com> <20080702010212.7b4b9301.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702010212.7b4b9301.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 01:02:12AM -0700, Andrew Morton wrote:
> On Wed, 02 Jul 2008 14:23:28 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> > drivers/mfd/sm501.c:39: error: field 'gpio' has incomplete type
> > 
> 
> Ben, can you please take a look?  I suspect the fix is to disable this
> driver on x86.
> 
Note that there are SM501 PCI cards that are architecture independent..
