Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZFJHh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZFJHh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 03:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZFJHhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 03:37:48 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:64861 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZFJHhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 03:37:47 -0400
Date: Wed, 10 Jun 2009 08:37:49 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <pierre@ossman.eu>, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Message-ID: <20090610073749.GA444@console-pimps.org>
References: <200905250243.46984.david-b@pacbell.net> <200905251659.17396.wolfgang.mues@auerswald.de> <20090609200750.2fa38dfe@mjolnir.ossman.eu> <200906100929.49553.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200906100929.49553.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 09:29:49AM +0200, Wolfgang Mües wrote:
> 
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o This patch changes the reported error code for the responses
>   to a command from EINVAL to EFAULT/ENOSYS, as EINVAL is reserved
>   for non-recoverable host errors, and the responses from
>   the SD/MMC card may be because of recoverable transmission
>   errors in the command or in the response. Response codes
>   in SPI mode are NOT protected by a checksum, so don't trust them.
> 
> This is a revised, minimal-invasive patch version. As Pierre Ossman
> pointed out, EINVAL should only be used for non-recoverable errors
> (and is used so in the whole rest of the mmc framework).
> 
> I have checked every instance of EINVAL in the mmc framework - no 
> changes were needed here. 
> 
> This patch is neccessary for doing a sensible retry managment in the 
> mmmc block layer (patch will follow).
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

Nice patch Wolfgang and well done for sticking this out ;-)

FWIW,
Acked-by: Matt Fleming <matt@console-pimps.org>
