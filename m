Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbYHSUvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbYHSUvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYHSUv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:51:27 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:6000 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYHSUv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:51:26 -0400
Subject: slower initcalls in -next
From: Daniel Walker <dwalker@mvista.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 13:51:24 -0700
Message-Id: <1219179084.18104.11.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was testing out todays -next I saw fastboot was included, which got me
interested so I made a  list of the slower initcalls. This was an
allyesconfig on 32bit x86, which means these numbers are somewhat
inflated w/ debugging enabled.
The top 25 below,

  initcall ub_init+0x0/0x76 returned 0 after 49465 msecs
  initcall rtrack_init+0x0/0xec returned 0 after 30529 msecs
  initcall net_olddevs_init+0x0/0x129 returned 0 after 25032 msecs
  initcall alsa_card_miro_init+0x0/0x19 returned 0 after 11562 msecs
  initcall cadet_init+0x0/0x156 returned -1 after 3173 msecs
  initcall mousedev_init+0x0/0x7d returned 0 after 2658 msecs
  initcall pty_init+0x0/0x449 returned 0 after 1735 msecs
  initcall tcpprobe_init+0x0/0xc3 returned 0 after 1388 msecs
  initcall sermouse_init+0x0/0x1b returned 0 after 1274 msecs
  initcall microcode_intel_module_init+0x0/0x43 returned 0 after 1247 msecs
  initcall ipx_init+0x0/0xd7 returned 0 after 1014 msecs
  initcall piix_init+0x0/0x29 returned 0 after 747 msecs
  initcall raid5_init+0x0/0x37 returned 0 after 648 msecs
  initcall init_rfd_ftl+0x0/0x14 returned 0 after 579 msecs
  initcall param_sysfs_init+0x0/0x143 returned 0 after 522 msecs
  initcall serial8250_init+0x0/0xef returned 0 after 507 msecs
  initcall init_sc520cdp+0x0/0x1d8 returned -5 after 415 msecs
  initcall isapnp_init+0x0/0xca6 returned 0 after 347 msecs
  initcall pci_init+0x0/0x31 returned 0 after 308 msecs
  initcall tty_init+0x0/0x19c returned 0 after 305 msecs
  initcall ehci_hcd_init+0x0/0x9f returned 0 after 305 msecs
  initcall alsa_card_sb8_init+0x0/0x19 returned -19 after 305 msecs
  initcall uhci_hcd_init+0x0/0xd4 returned 0 after 297 msecs
  initcall com90xx_init+0x0/0xd6f returned -5 after 293 msecs
  initcall alsa_card_wavefront_init+0x0/0x52 returned 0 after 286 msecs

I don't know to what degree these are already being investigated, but I
thought the list was interesting ..

Daniel

