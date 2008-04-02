Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbYDBO3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbYDBO3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbYDBO3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:29:44 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:52930 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497AbYDBO3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:29:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Wed, 2 Apr 2008 16:29:40 +0200
User-Agent: KMail/1.9.9
References: <200804021524.27222.elendil@planet.nl> <20080402135729.GB24239@csclub.uwaterloo.ca>
In-Reply-To: <20080402135729.GB24239@csclub.uwaterloo.ca>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021629.41153.elendil@planet.nl>
X-OriginalArrivalTime: 02 Apr 2008 14:29:41.0319 (UTC) FILETIME=[FCF52570:01C894CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Lennart Sorensen wrote:
> How old is that system?

Not sure. As the system only has 32MB RAM I'd say sometime late 1990s.

> Maybe the IDE isn't even PCI based.  That would explain why nothing shows
> in lspci, but the IDE ports are still present and working.

Could be. What would it be then? ISA? Any way to recognize that?

I did find a product page, but it's low on real specs:
http://www.toshiba.ca/web/product.grp?lg=en&section=1&group=223&product=1605

> One could always just manually tell the system to always load
> ide-generic, since deciding what to load does seem to be a userspace
> choice these days.

Well, in the Debian Installer we prefer to load things automatically 
whenever possible. If the kernel does not do it, that's fine.

But to have the installer itself automatically load ide-generic for the 
user, we'd still have to somehow recognize that we need the driver.
Any ideas/suggestions what to look for?

Cheers,
FJP
