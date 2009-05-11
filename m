Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbZEKV1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbZEKV1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbZEKV1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:27:23 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:39604 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbZEKV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:27:22 -0400
MIME-Version: 1.0
In-Reply-To: <20090511221947.50eda8d5@lxorguk.ukuu.org.uk>
References: <20090509143742.GA27663@kroah.com> <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil> 
	<20090511175626.GA4758@kroah.com> <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil> 
	<ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com> 
	<20090511221947.50eda8d5@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 23:27:01 +0200
Message-ID: <ac3eb2510905111427g1ac667fajcf8de31b15eb6dcd@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 23:19, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> By doing its own fstype, we could also make the auto-mount optional,
>> because you could always reach the filesystem anytime later.
>
> Killing the automount would also fix a lot of the other problems as you
> can then mount it in the initrd and dump it when you have the real fs up,
> or you can mount it privately thanks to Al Viro's magic with mount points
> and only the daemon that must make the "real" device file system need
> have it mounted and accessible.

Sounds good.

>> A different fstype has the slight inconvenience, that existing
>> userspace needs to be taught to handle it explicitly, while a tmfps is
>> already handled automatically because we use tmpfs already today. But
>> that may not be too important.
>
> Thats a good thing - it stops some of the suprise behaviour the Eric
> pointed out and objected to.

I'll give it try. Any name suggestions to throw at that thing? :)

>> Thanks a lot for your tests and analysis,
>
> And I think btw the underlying failure was in the tty layer - I just need
> to find it. It's the second report vaguely of this form so something is
> lurking in the stygian depths.

Ah, good. So that was a useful outcome of it at least. :)

Thanks,
Kay
