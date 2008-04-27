Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYD0Cz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYD0Cz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 22:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYD0Czt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 22:55:49 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43718 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYD0Czs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 22:55:48 -0400
Date: Sat, 26 Apr 2008 22:55:47 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (no disks with sata_nv)
Message-ID: <20080427025547.GC24710@havoc.gtf.org>
References: <29495f1d0804261912k584cb68p36f4b9e5401afbb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0804261912k584cb68p36f4b9e5401afbb8@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 07:12:58PM -0700, Nish Aravamudan wrote:
> 
> While trying to test the hugepage changes pending for -mm, I found
> that none of my 4 disks attached to
> 
> nVidia Corporation CK804 Serial ATA Controller (rev f3)
> 
> come up (and thus I am dropped to an initramfs shell). The driver is
> loading and indicates a link up on all 4 ports that are involved, but
> I see no sd/sdX messages like I do with 2.6.25 (which I'm using right
> now). I've started the bisection, but if Jeff or anyone has any ideas,
> I'd appreciate it. I don't have a serial console on this box, and no
> oops is produced. .configs from 2.6.25 and 2.6.25-mm1 attached.

Should be fixed in upstream, so I presume it will appear when Andrew
next updates his kernel to the latest upstream.

	Jeff



