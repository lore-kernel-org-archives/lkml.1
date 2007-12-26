Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbXLZPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbXLZPpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 10:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXLZPpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 10:45:40 -0500
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:45491 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751076AbXLZPpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 10:45:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=1XeCeTssP8haJM8DIhy7IiqPJiqekEnx22AA/3DU8l5nEPjnGLuDIyH0GYV2kNhGRRAK+ew4etqshj0PB39e3xM6XIm/n7twcMCURWnFItU7LpnmMJvgRtopoBaPoJJ7PESF5elDFCLk+kG4gsmgG8eNsbGwrIaTKfGYwGbRdr0=  ;
X-YMail-OSG: r5EBFiAVM1ljLgtbb32PHnnvDLw0CAfPSACUW29WIOpWhbWHOz9.M8NFesrS4ObxeXrvgcwfRQ--
Date: Wed, 26 Dec 2007 16:43:29 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/63] ide-cd: redux
Message-ID: <20071226154329.GA4713@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Andrew Morton <akpm@linux-foundation.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200712200148.49690.bzolnier@gmail.com> <20071225140514.fa13f5ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071225140514.fa13f5ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2007 at 02:05:14PM -0800, Andrew Morton wrote:
> On Thu, 20 Dec 2007 01:48:49 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > This patch series is a major rework of the ide-cd driver.
> 
> woo-hoo.
> 
> > PS ide-cd Maintainer position is still open...
> 
> boo-hoo.
> 
> I wish someone would fix that "The drive appears confused (ireason =
> 0x%02x)" thing.  I had a go a while back but iirc the reporter disappeared
> on me.  It is somewhat common.
> 
> Or do you think this patch might indeed fix it?

Andrew, take a look at patch #12 in this series: "ide-cd: fix "missing data" handling in
cdrom_pc_intr()."
-- 
Regards/Gruﬂ,
    Boris.
