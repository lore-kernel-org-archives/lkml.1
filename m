Return-Path: <linux-kernel-owner+w=401wt.eu-S1423216AbXBCMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423216AbXBCMHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 07:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423214AbXBCMHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 07:07:19 -0500
Received: from mx02.qsc.de ([213.148.130.14]:44812 "EHLO mx02.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945911AbXBCMHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 07:07:18 -0500
From: Rene Rebe <rene@exactcode.de>
Organization: ExactCODE
To: "Patrick Ale" <patrick.ale@gmail.com>
Subject: Re: hdparm for lib_pata
Date: Sat, 3 Feb 2007 13:07:02 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <8d158e1f0702030041xaa34440r125a39a85d498f4c@mail.gmail.com> <8d158e1f0702030055l39b7cc9eg6e9b36862a4b495d@mail.gmail.com>
In-Reply-To: <8d158e1f0702030055l39b7cc9eg6e9b36862a4b495d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702031307.03179.rene@exactcode.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: Spam detection software, running on the system "grum.localhost", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Saturday 03 February 2007 09:55:52 Patrick Ale wrote:
	> Hi, > > The problem is even worse, the drive falls back to PIO mode
	and there > is no way I can get it back to dma mode (like I could by
	using > hdparm). The only thing i can do is reboot the machine so it
	will see > the drive is UDMA capable. > > If there is some beta/gamma
	software around or something you'd like to > have tested, you can mail
	me directly, my machine is your private > prostitute at the moment, it's
	not like i have something important to > do with the machine anyway (not
	related to this problem):) [...] 
	Content analysis details:   (-1.4 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.4 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 February 2007 09:55:52 Patrick Ale wrote:
> Hi,
> 
> The problem is even worse, the drive falls back to PIO mode and there
> is no way I can get it back to dma mode (like I could by using
> hdparm). The only thing i can do is reboot the machine so it will see
> the drive is UDMA capable.
> 
> If there is some beta/gamma software around or something you'd like to
> have tested, you can mail me directly, my machine is your private
> prostitute at the moment, it's not like i have something important to
> do with the machine anyway (not related to this problem):)

The libata expoted disls have a SCSI ioctl interface, sdparm should
work on those.

-- 
  René Rebe - ExactCODE GmbH - Europe, Germany, Berlin
  http://exactcode.de | http://t2-project.org | http://rene.rebe.name
  +49 (0)30 / 255 897 45
