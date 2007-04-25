Return-Path: <linux-kernel-owner+w=401wt.eu-S2993039AbXDYUDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993039AbXDYUDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993041AbXDYUDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:03:04 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25219 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993039AbXDYUDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:03:00 -0400
Date: Wed, 25 Apr 2007 13:05:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm1: Oops and Gnome desktop freezes
Message-Id: <20070425130518.504111fd.randy.dunlap@oracle.com>
In-Reply-To: <20070425121242.52698643.akpm@linux-foundation.org>
References: <1177512596.4856.17.camel@daplas>
	<20070425121242.52698643.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 12:12:42 -0700 Andrew Morton wrote:

> On Wed, 25 Apr 2007 22:49:56 +0800 "Antonino A. Daplas" <adaplas@gmail.com> wrote:
> 
> > The Gnome desktop does not finish launching.  And I get this tracing,
> > all coming from Gnome apps.
> > 
> > Tony
> > 
> > BUG: unable to handle kernel paging request at virtual address c0a74000
> 
> This might have been caused by the now-dropped
> mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
> 
> 
> >  printing eip:
> > c014c469
> > *pde = 005f3027
> > *pte = 00000000
> > Oops: 0002 [#1]
> > Modules linked in: xt_pkttype xt_tcpudp ipt_LOG xt_limit nfsd exportfs
> > lockd nfs_acl sunrpc snd_pcm_oss snd_mixer_oss snd_seq button battery ac
> > ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter
> > ip6table_filter nf_conntrack_ipv4 nf_conntrack ip_tables ip6_tables
> > x_tables nls_iso8859_1 nls_cp437 vfat fat nls_utf8 ntfs reiserfs loop
> > usblp snd_via82xx snd_ac97_codec ac97_bus snd_pcm ide_cd cdrom snd_timer
> > snd_page_alloc snd_mpu401_uart rtc_cmos snd_rawmidi rtc_core
> > snd_seq_device rtc_lib snd soundcore via_rhine ehci_hcd uhci_hcd usbcore
> > sc92031 via_agp 8139too i2c_viapro ext3 mbcache jbd edd fan thermal
> > processor via82cxxx ide_disk ide_core
> > CPU:    0
> > EIP:    0060:[<c014c469>]    Tainted: G      D VLI
> 
> For some reason all oopses (and boy there are a lot of them) are being
> described as tainted.

probably the recent die_counter/Oops implies Tainted patch.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
