Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYGIHLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYGIHLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 03:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYGIHLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 03:11:14 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:46800 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYGIHLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 03:11:14 -0400
Date: Wed, 9 Jul 2008 08:26:40 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, pHilipp Zabel <philipp.zabel@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, sameo@openedhand.com,
       linux-kernel@vger.kernel.org
Message-ID: <20080709062640.GC8087@datenfreihafen.org>
References: <20080707184000.411913919@datenfreihafen.org> <20080707184129.554483476@datenfreihafen.org> <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com> <20080707200251.GA3449@datenfreihafen.org> <48730DE2.2050302@gmail.com> <4873734F.4030808@gmail.com> <20080708203213.GF18479@datenfreihafen.org> <487423B3.3010604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487423B3.3010604@gmail.com>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [Patch 06/10] mfd: PCAP driver for the Motorola EZX GSM mobile
	phones
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Wed, 2008-07-09 at 10:34, Eric Miao wrote:
> 
> > o Eric, what do you like the PCAP_REDIRECT_IRQ flag to do?
> > 
> 
> I'm seeing the following the block of code in the original patch:
>  
> +/* PCAP */
> +static int ezx_pcap_init(void)
> +{
> 
> ...
> 
> +	/* redirect all interrupts to AP */
> +	if (!(machine_is_ezx_a780() || machine_is_ezx_e680()))
> +		ezx_pcap_write(PCAP_REG_INT_SEL, 0);
> +
> +	return 0;
> +}
> 
> that prevent this driver from being generic, a flag of PCAP_REDIRECT_IRQ
> might be used to decide the writing to PCAP_REG_INT_SEL is necessary.

Ok, now we got it. :)

Will do as requested. Array changes are pending and we also have some more
cleanups open. Will send a new patch when we have this ready.

regards
stefan Schmidt
