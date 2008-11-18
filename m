Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYKRTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYKRTzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 14:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYKRTzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 14:55:08 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:11241 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYKRTzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 14:55:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qRbAHJsMGM3CYXRTyLeh6wQrWdTjHvUX4CYjwOe5qE9z2tYhrStcLPUdJsXw+cfiZ7
         MnmqJI+7YW8afAtLToYBB3WQoldpx/O5fkWUijyNISymBXXmX/zXFAHWMQUNYrWC258d
         tpCV9z3uTExyGcQj64NoFd8ndk/hPOnivbYR4=
Date: Tue, 18 Nov 2008 20:54:33 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] cdrom: split mmc_ioctl to lower stack usage
Message-ID: <20081118195429.GA6010@joi>
References: <20081116180437.GC6282@joi> <20081117121134.GM26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117121134.GM26778@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 01:11:34PM +0100, Jens Axboe wrote:
> On Sun, Nov 16 2008, Marcin Slusarz wrote:
> > Checkstack output:
> > 
> > Before:
> > mmc_ioctl:                  584
> > 
> > After:
> > mmc_ioctl_dvd_read_struct:  280
> > mmc_ioctl_cdrom_subchannel: 152
> > mmc_ioctl_cdrom_read_data:  120
> > mmc_ioctl_cdrom_volume:     104
> > mmc_ioctl_cdrom_read_audio: 104
> > (mmc_ioctl is inlined into cdrom_ioctl - 104 bytes)
> 
> Looks good (both 1 and 2). What kind of testing have you done? I have
> applied it to for-2.6.29.

Only very basic testing - I can play audio cd's via amarok (CDROMREADRAW)
and kscd (CDROMREADAUDIO).

Marcin
