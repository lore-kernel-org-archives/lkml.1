Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0BGV3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 16:29:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab0BGV3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 16:29:36 -0500
Date: Sun, 7 Feb 2010 23:26:19 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc6: ext4 triggers warning about high order allocations
Message-ID: <20100207212619.GA3226@redhat.com>
References: <20100203060854.GA12489@redhat.com> <4B69AB60.5070609@redhat.com> <20100203175836.GA16907@redhat.com> <4B69CCE4.3000904@redhat.com> <20100207123032.GA3220@redhat.com> <4B6F0DE5.7060100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6F0DE5.7060100@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 01:00:53PM -0600, Eric Sandeen wrote:
> > I have removed auto_da_alloc option, but still see a warning at boot:
> 
> Any chance you've still got it in an initrd or grub rootfs options, or similar?

Looks like this was the case: I rebuilt initrd and it's gone.

