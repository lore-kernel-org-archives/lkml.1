Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZAaNrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZAaNrH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 08:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZAaNqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 08:46:55 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53042 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbZAaNqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 08:46:55 -0500
X-Sasl-enc: zrUCpA5uC6EWIXioEo4F5LsUnXc/eEkVJgvSZzbz77tT 1233409614
Date: Sat, 31 Jan 2009 11:46:51 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Manfred Wassmann <tux.wassmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Spurious Filesystem corruption with ext3 + large (<400GB) hw
	RAID partition + SMP
Message-ID: <20090131134651.GC28763@khazad-dum.debian.net>
References: <6bd94bae0901310536l2cd42fa1off60ee066fa0096b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bd94bae0901310536l2cd42fa1off60ee066fa0096b@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009, Manfred Wassmann wrote:
> I'm experiencing spurious filesystem corruption problems with ext3 on
> a partition larger than 400 GB on a hardware SATA RAID.

Please describe the SATA RAID hardware in a bit more detail.  Which
SATA controller does it use?

Also, have you made sure it is not caused by bad memory?

> The problems first occured on an Intel dual core system with a custom
> installation DVD which uses a 32 bit 2.6.26 kernel with SMP enabled
> and a 4GB memory limit. The problems occured only randomly but it was
> possible to reproduce them reliably with a standard Ubunu installation
> disk using a 2.6.27-7 kernel (apparently also 32bit SMP kernel w 4GB
> limit).
> When installing Ubuntu a message appears in the kernel log stating:
> "EXT3-fs error (device sda6): ext3_vlid_block_bitmap: Invalid block
> bitmap - block_group = 3076, block = <some large number>"
> This message is the first indication of any problem, the filesystem is
> then remounted readonly and the installation stops understandably.
> 
> The problem does only occur with an ext3 filesystem, installation
> using an xfs filesystem completes without error.
> 
> Furthermore with the installation from my custom installation DVD
> succeeded, which installs a prebuild Debian etch system featuring a 64
> bit monolithic 2.6.26 kernel, i was able to stress the system to its
> limits using the stress and dbench programs without any sign of
> filesystem corruption.
> 
> As XFS does substantially outperform ext3 under the given
> circumstances I'm going to use that but if someone wants to
> investigate the problem and needs further details I'll do my very best
> ;-)

Be careful.  XFS might not trigger the problem as readly, but it could
still be there and you can suffer data loss.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
