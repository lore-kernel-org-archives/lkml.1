Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZFTX0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZFTX0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 19:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZFTX0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 19:26:08 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:61141 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbZFTX0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:26:07 -0400
From: Frans Pop <elendil@planet.nl>
To: Sean MacLennan <smaclennan@pikatech.com>
Subject: Re: Badness on the Warp
Date: Sun, 21 Jun 2009 01:26:08 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20090620154824.72b5cd50@lappy.seanm.ca> <200906202256.46073.elendil@planet.nl> <20090620191034.48fa085a@lappy.seanm.ca>
In-Reply-To: <20090620191034.48fa085a@lappy.seanm.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906210126.09049.elendil@planet.nl>
X-OriginalArrivalTime: 20 Jun 2009 23:26:09.0728 (UTC) FILETIME=[7E279400:01C9F1FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 June 2009, Sean MacLennan wrote:
> On Sat, 20 Jun 2009 22:56:45 +0200 Frans Pop <elendil@planet.nl> wrote:
> > The fact that your bisect ended at a merge essentially means that it
> > is invalid. As a merge does not introduce any actual change (unless
> > it includes changes to resolve conflicts), it normally cannot be the
> > cause of a regression.
>
> Makes sense I messed up somewhere. This is the commit that causes
> problems:
>
> Merge branch 'topic/slab/earlyboot' of
> git://git./linux/kernel/git/penberg/slab-2.6
>
> * 'topic/slab/earlyboot' of
> git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6:

Hmmm. That's b640f042faa2, which is another merge...
So you're still not there.
