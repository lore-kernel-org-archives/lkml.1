Return-Path: <linux-kernel-owner+w=401wt.eu-S966552AbYD1Sdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966552AbYD1Sdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965486AbYD1Sal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:30:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:56232 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966137AbYD1Sai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=eVE+8LsR7/TtkbbcFKfEhQaJmOEQHBg85qQOwIxNVGK3kCq9/II/D2NdE+8ciiMEp72lpxrAHYz1LD/zRQEudjBmCp6S/eTGctVdD/0EBtcoxlV9PtA7EYYZ+HjduTdwUgp5XyoGYwA7sWsHrBJgqi+kOV7yZajpw0Mhz5dru/U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.25-mm1: Failing to probe IDE interface
Date: Mon, 28 Apr 2008 20:44:34 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <20080428164235.GA29229@csn.ul.ie>
In-Reply-To: <20080428164235.GA29229@csn.ul.ie>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804282044.34783.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 28 April 2008, Mel Gorman wrote:
> An old T21 is failing to boot and the relevant message appears to be
> 
> [    1.929536] Probing IDE interface ide0...
> [   36.939317] ide0: Wait for ready failed before probe !
> [   37.502676] ide0: DISABLED, NO IRQ
> [   37.506356] ide0: failed to initialize IDE interface
> 
> The owner of ide-mm-ide-add-struct-ide_io_ports-take-2.patch with the
> "DISABLED, NO IRQ" message is cc'd. I've attached the config, full boot log
> and lspci -v for the machine in question. I'll start reverting some of the
> these patches to see if ide-mm-ide-add-struct-ide_io_ports-take-2.patch
> is really the culprit.

Please try reverting ide-fix-hwif-s-initialization.patch first - it has
already been dropped from IDE tree because people were reporting problems
similar to the one encountered by you.

Thanks,
Bart
