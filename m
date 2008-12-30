Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYL3OUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYL3OUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 09:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYL3OUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 09:20:32 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:58965 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYL3OUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 09:20:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d1oHzOXZpBqqbunnfN/Sj03os2witUeeIxtSOWSFaZVafeecn2wJCqg6inKlvqTuxU
         zqbzg4oJvtUzYaF1dBJ1mgdX4rjBMExh6DKQGDzbVzRtE9jf0rFMHtRyBx8QqKY5MHjo
         c/nzWHpQWzZpCBKe4yiJhc1gmefxXypsgXCcs=
Date: Tue, 30 Dec 2008 08:20:26 -0600
From: Matt Garman <matthew.garman@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       smartmontools-support@lists.sourceforge.net,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: mismatch_cnt, random bitflips, silent corruption(?), mdadm/sw
	raid[156]
Message-ID: <20081230142026.GB3549@sewage.raw-sewage.fake>
References: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 01:04:07PM -0500, Justin Piszcz wrote:
> Options/alternatives for maintaining data integrity?
>
> 1. Obviously DVD and/or LTO-tape (multiple copies of data at rest)
> http://epoka.dk/media/Linear_Tape_Open_(LTO)_Ultrium_Data_Cartridges.pdf
> -> For LTO-2/LTO-3
> -> Uncorrected bit error rate 1x10-17 1x10-17
> -> Undetected bit error rate 1x10-27 1x10-27
>
> 2. ZFS, but only runs in user-space in Linux.
>
> 3. Keep an md5sum for each file on the filesystem and run daily
> checks?

I've recently started using par2[1][2] on backed up files.

I just started doing this, so don't know how it will work in the
long run.  Can't hurt, anyway, other than taking up more space.

[1] http://www.par2.net/
[2] http://parchive.sourceforge.net/

