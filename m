Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbXLJQul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbXLJQul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXLJQud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:50:33 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:59798 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbXLJQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:50:32 -0500
Date: Mon, 10 Dec 2007 09:50:30 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com
Subject: Re: [PATCH][SCSI] hptiop: add more adapter models and other fixes
Message-ID: <20071210165030.GB26334@parisc-linux.org>
References: <200712101354.53575.linux@highpoint-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712101354.53575.linux@highpoint-tech.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 01:54:53PM +0800, HighPoint Linux Team wrote:
> Most code changes were made to support adapters based on Marvell IOP, plus some
> other fixes.
> 
> - add more PCI device IDs
> - support for adapters based on Marvell IOP

Are you sure it's a good idea to do this?  This patch is 1200 lines long
... the same size as the existing driver:

$ wc drivers/scsi/hptiop.*
  947  2273 24531 drivers/scsi/hptiop.c
  256   612  6175 drivers/scsi/hptiop.h
  1203  2885 30706 total

That suggests to me there's not much commonality between the two drivers,
and you'd be better off adding a second driver for the 4xxx cards.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
