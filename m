Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZGNN3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZGNN3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZGNN3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:29:07 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37658 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbZGNN3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:29:06 -0400
Subject: Re: [PATCH 5/5] Make SCSI SG v4 driver enabled by default and
 remove EXPERIMENTAL dependency, since udev depends on BSG.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: John Stoffel <john@stoffel.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <4A5C27D4.5040204@panasas.com>
References: <1247513973-24899-1-git-send-email-john@stoffel.org>
	 <19035.36432.181354.977939@stoffel.org>  <4A5C27D4.5040204@panasas.com>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 09:29:01 -0400
Message-Id: <1247578141.4310.34.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 09:38 +0300, Boaz Harrosh wrote:
> On 07/13/2009 10:43 PM, John Stoffel wrote:
> >>>>>> "John" == John Stoffel <john@stoffel.org> writes:
> > 
> > Dammit, I messed up here sending this patch.  I've just edited the
> > subject line and re-sent it with a bit more description.  I think this
> > patch is perfectly good to go into 2.6.31 right now, esp since it's
> > not changing code, just whether the code is turned on by default from
> > now on.
> > 
> 
> I would like it if you'd also CC stable@kernel.org on this patch. As this
> condition is already true for distros in the field.

The stable tree is for bug *fixes*.   Moving an option out from under
experimental is basically an enhancement, even if it could be argued it
should have been done long ago.

James


