Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZBXMj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZBXMj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbZBXMjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:39:13 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:51010 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZBXMjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:39:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GXT9OYRDoqTGHG92Dq0KFAfau5KfOYsksoSzWrxdc/YtmTDeeDS9PSTFM6hcvLfAXm
         gPaOZPxGzAsVoYGQ4Ij/IIsSenpth26ESz9kDln7+fRRwdTVPAnnFXYlgalnTC1hnpfB
         TuFoFAQ/5XSL5mqsRcAk7I2luc14vvg5/wfhs=
Date: Tue, 24 Feb 2009 13:38:43 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn warning in 2.6.29-rc6
Message-ID: <20090224123843.GA4059@Pilar.aei.mpg.de>
References: <20090223212615.GA5047@Pilar.Speedport_W_303V_Typ_A> <1235429106.18617.42.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235429106.18617.42.camel@rc-desk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 23.Feb'09 at 14:45:06 -0800, reinette chatre wrote:
> On Mon, 2009-02-23 at 13:26 -0800, Carlos R. Mafra wrote:
> > I've just got this warning in my Vaio laptop:
> > 
> > ------------[ cut here ]------------
> > WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1254 iwl_tx_cmd_complete+0x28a/0x2e0()
> > Hardware name: VGN-FZ240E
> > wrong command queue 31, sequence 0x7FFF readp=241 writep=241
> > Modules linked in: usbhid nvram snd_hda_codec_idt snd_hda_intel snd_hda_codec uvcvideo snd_hwdep snd_pcm iwlagn videodev snd_timer sky2 v4l1_compat v4l2_compat_ioctl32 evdev sg i2c_i801 snd_page_alloc sr_mod ata_piix ahci libata sd_mod scsi_mod uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
> > Pid: 0, comm: swapper Not tainted 2.6.29-rc6 #37
> > [...]
> 
> This sounds like
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703 for
> which new uCode was released to address the problem. Could you please
> try with the most recent 4965 uCode available from
> http://www.intellinuxwireless.org/?n=Downloads ?

Ok, I tried it and so far got no warnings at all.

I will keep looking the dmesg for a few days, and if you
don't hear back from me that means it is gone for good.

Thanks for your prompt answer!
