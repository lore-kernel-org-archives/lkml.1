Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZEAQty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZEAQty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZEAQtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:49:46 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:56416 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbZEAQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:49:45 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: What's in hid.git for 2.6.30
Date: Fri, 1 May 2009 18:49:48 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.0903251742520.14346@wotan.suse.de> <200905011809.19971.oliver@neukum.org> <alpine.LNX.2.00.0905011812330.22532@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0905011812330.22532@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011849.49050.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 1. Mai 2009 18:16:11 schrieb Jiri Kosina:
> > Will hid forget that a key had been pressed? I must admit that I can't
> > tell where in hid the key repetition logic is located.
>
> The repetition is fully handled in the input core, not in the hid-input
> driver. So if the device is not handled by hid-input, we (the kernel
> driver) haven't registered with the input subsystem, and therefore no
> events go to input subsystem at all.

OK, I see. All is well, the patch is good.

	Regards
		Oliver

