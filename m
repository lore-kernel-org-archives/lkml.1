Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYGPBOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYGPBOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYGPBOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:14:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:36834 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYGPBOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TWh8Jit2pLMFfObh8v7MoiiLV2KpRtgnA59ktxFGzehE+6V9Mw/23p/MJVnBus54Oq
         naFIWEy+Dqmk+zXxQolu5p7OkP5ULpmaepk9pij2hNhWk+ppDpHh5Ltb0UEyFNVrMKIG
         QX4RrpeUbtDo/8BiAJ24c1VmdpcrkekOzubas=
Date: Wed, 16 Jul 2008 05:11:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, david@lang.hm,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Prosaic firmware issues
Message-ID: <20080716011140.GA30967@martell.zuzino.mipt.ru>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org> <200807160222.40705.elendil@planet.nl> <alpine.LFD.1.10.0807151726520.2867@woody.linux-foundation.org> <487D441B.5010908@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D441B.5010908@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could somebody from firmware people fix boring stuff, please:

1) after allyesconfig build, git-status show plenty of crap:

#	firmware/atmsar11.fw
#	firmware/atmsar11.fw.gen.S
#	firmware/cpia2/stv0672_vp4.bin.gen.S
#	firmware/dabusb/bitstream.bin.gen.S
#	firmware/dabusb/firmware.fw
#	firmware/dabusb/firmware.fw.gen.S
#	firmware/edgeport/boot.fw
#	firmware/edgeport/boot.fw.gen.S
#	firmware/edgeport/boot2.fw
#	firmware/edgeport/boot2.fw.gen.S
#	firmware/edgeport/down.fw
#	firmware/edgeport/down.fw.gen.S
#	firmware/edgeport/down2.fw
#	firmware/edgeport/down2.fw.gen.S
#	firmware/edgeport/down3.bin.gen.S
#	firmware/emi26/bitstream.fw
#	firmware/emi26/bitstream.fw.gen.S
#	firmware/emi26/firmware.fw
#	firmware/emi26/firmware.fw.gen.S
#	firmware/emi26/loader.fw
#	firmware/emi26/loader.fw.gen.S
#	firmware/emi62/bitstream.fw
#	firmware/emi62/bitstream.fw.gen.S
#	firmware/emi62/loader.fw
#	firmware/emi62/loader.fw.gen.S
#	firmware/emi62/midi.fw
#	firmware/emi62/midi.fw.gen.S
#	firmware/emi62/spdif.fw
#	firmware/emi62/spdif.fw.gen.S
#	firmware/ess/maestro3_assp_kernel.fw
#	firmware/ess/maestro3_assp_kernel.fw.gen.S
#	firmware/ess/maestro3_assp_minisrc.fw
#	firmware/ess/maestro3_assp_minisrc.fw.gen.S
#	firmware/ihex2fw
#	firmware/intelliport2.bin.gen.S
#	firmware/kaweth/new_code.bin.gen.S
#	firmware/kaweth/new_code_fix.bin.gen.S
#	firmware/kaweth/trigger_code.bin.gen.S
#	firmware/kaweth/trigger_code_fix.bin.gen.S
#	firmware/keyspan/mpr.fw
#	firmware/keyspan/mpr.fw.gen.S
#	firmware/keyspan/usa18x.fw
#	firmware/keyspan/usa18x.fw.gen.S
#	firmware/keyspan/usa19.fw
#	firmware/keyspan/usa19.fw.gen.S
#	firmware/keyspan/usa19qi.fw
#	firmware/keyspan/usa19qi.fw.gen.S
#	firmware/keyspan/usa19qw.fw
#	firmware/keyspan/usa19qw.fw.gen.S
#	firmware/keyspan/usa19w.fw
#	firmware/keyspan/usa19w.fw.gen.S
#	firmware/keyspan/usa28.fw
#	firmware/keyspan/usa28.fw.gen.S
#	firmware/keyspan/usa28x.fw
#	firmware/keyspan/usa28x.fw.gen.S
#	firmware/keyspan/usa28xa.fw
#	firmware/keyspan/usa28xa.fw.gen.S
#	firmware/keyspan/usa28xb.fw
#	firmware/keyspan/usa28xb.fw.gen.S
#	firmware/keyspan/usa49w.fw
#	firmware/keyspan/usa49w.fw.gen.S
#	firmware/keyspan/usa49wlc.fw
#	firmware/keyspan/usa49wlc.fw.gen.S
#	firmware/keyspan_pda/keyspan_pda.fw
#	firmware/keyspan_pda/keyspan_pda.fw.gen.S
#	firmware/keyspan_pda/xircom_pgs.fw
#	firmware/keyspan_pda/xircom_pgs.fw.gen.S
#	firmware/korg/k1212.dsp
#	firmware/korg/k1212.dsp.gen.S
#	firmware/ti_3410.fw
#	firmware/ti_3410.fw.gen.S
#	firmware/ti_5052.fw
#	firmware/ti_5052.fw.gen.S
#	firmware/ttusb-budget/dspbootcode.bin.gen.S
#	firmware/vicam/firmware.fw
#	firmware/vicam/firmware.fw.gen.S
#	firmware/whiteheat.fw
#	firmware/whiteheat.fw.gen.S
#	firmware/whiteheat_loader.fw
#	firmware/whiteheat_loader.fw.gen.S
#	firmware/yamaha/ds1_ctrl.fw
#	firmware/yamaha/ds1_ctrl.fw.gen.S
#	firmware/yamaha/ds1_dsp.fw
#	firmware/yamaha/ds1_dsp.fw.gen.S
#	firmware/yamaha/ds1e_ctrl.fw
#	firmware/yamaha/ds1e_ctrl.fw.gen.S

2) after "make mrproper" after allyesconfig, some files aren't removed,
   use "git-ls-files -o" to see them.

#	firmware/atmsar11.fw
#	firmware/dabusb/firmware.fw
#	firmware/emi26/bitstream.fw
#	firmware/emi26/firmware.fw
#	firmware/emi26/loader.fw
#	firmware/emi62/bitstream.fw
#	firmware/emi62/loader.fw
#	firmware/emi62/midi.fw
#	firmware/emi62/spdif.fw
#	firmware/ess/maestro3_assp_kernel.fw
#	firmware/ess/maestro3_assp_minisrc.fw
#	firmware/korg/k1212.dsp
#	firmware/yamaha/ds1_ctrl.fw
#	firmware/yamaha/ds1_dsp.fw
#	firmware/yamaha/ds1e_ctrl.fw

