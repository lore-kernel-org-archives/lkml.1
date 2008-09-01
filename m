Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYIAHM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYIAHM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYIAHMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:12:19 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:58922 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbYIAHMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:12:19 -0400
Date: Mon, 1 Sep 2008 09:12:06 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Zid Null <zidsoft@gmail.com>
Cc: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Linux 2.6.27-rc5
Message-ID: <20080901071206.GA5536@electric-eye.fr.zoreil.com>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <20080901012726.7c717aaf@werewolf.home> <328e43f00808311825r71164541pd4159a4a33b9b038@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <328e43f00808311825r71164541pd4159a4a33b9b038@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(thanks for the forward Zid)

Zid Null <zidsoft@gmail.com> :
> 2008/9/1 J.A. Magallón <jamagallon@ono.com>
> > On Thu, 28 Aug 2008 16:26:45 -0700 (PDT), Linus Torvalds <
> > torvalds@linux-foundation.org> wrote:
[...]
> > > Another week (my weeks do seem to be eight days, don't they? Very odd),
> > > another -rc.
[...]
> > r8169 is not working on an Aspire One. It looked like working some time,
> > but now it has begun to say:
> >
> > Sep  1 01:09:35 one klogd: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> > Sep  1 01:09:35 one klogd: r8169 0000:02:00.0: PCI INT A -> GSI 17 (level,
> > low) -> IRQ 17
> > Sep  1 01:09:35 one klogd: r8169 0000:02:00.0: cache line size of 32 is not
> > supported
> > Sep  1 01:09:35 one klogd: r8169 0000:02:00.0: PCI INT A disabled
> > Sep  1 01:09:35 one klogd: r8169: probe of 0000:02:00.0 failed with error
> > -22
> >
> > Any ideas ? Any more info needed ?
> >
> > TIA
> >
> > one:/var/log# lspci -vv -s 02:00.0
> > 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E PCI
> > Express Fast Ethernet controller (rev ff) (prog-if ff)
> >    !!! Unknown header type 7f
> >    Kernel modules: r8169

Send a lspci -vvx but I guess that it is all 'ff' when the problem happens.

Either it is reliably fixed with patches #0001 ... #0006 at
http://userweb.kernel.org/~romieu/r8169/2.6.27-rc3/20080818/
or something broke in the PCI configuration space.

-- 
Ueimor
