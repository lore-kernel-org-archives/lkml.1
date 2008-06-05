Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbYFEXMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbYFEXMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763956AbYFEXLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:11:37 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54590 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763358AbYFEXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:11:35 -0400
Subject: Re: [PATCH] FIx crash in mmc_block on 64-bit
From: Ben Collins <ben.collins@canonical.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       kernel-team <kernel-team@lists.ubuntu.com>
In-Reply-To: <20080605232513.3f5cb48f@mjolnir.drzeus.cx>
References: <1212428359.7239.4.camel@cunning>
	 <20080605232513.3f5cb48f@mjolnir.drzeus.cx>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 05 Jun 2008 19:11:34 -0400
Message-Id: <1212707494.4276.560.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 23:25 +0200, Pierre Ossman wrote:
> On Mon, 02 Jun 2008 13:39:19 -0400
> Ben Collins <ben.collins@canonical.com> wrote:
> 
> > Fairly simple. "dev_use" was being allocated as a zero length array
> > because of bad math on 64-bit systems causing a crash in
> > find_first_zero_bit(). One-liner follows:
> > 
> 
> A signed-off-by to make things nice and proper, please. :)
> 
> You can add an Acked-by: Pierre Ossman <drzeus@drzeus.cx> and pass it
> on directly to Linus.

Not sure how I missed the signed-off-by, but resent to Linus with your
ack. Thanks

