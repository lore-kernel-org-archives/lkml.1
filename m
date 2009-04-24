Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZDXTCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZDXTCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDXTCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:02:30 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:55273 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbZDXTC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:02:29 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] 2.6.30-rc3: bnx2 failing to load firmware
Date: Fri, 24 Apr 2009 21:02:26 +0200
User-Agent: KMail/1.9.9
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       mchan@broadcom.com, davem@davemloft.net
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <200904242031.52793.elendil@planet.nl> <alpine.LFD.2.00.0904241135570.3101@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904241135570.3101@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904242102.28011.elendil@planet.nl>
X-OriginalArrivalTime: 24 Apr 2009 19:02:28.0427 (UTC) FILETIME=[3660E1B0:01C9C50F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 April 2009, Linus Torvalds wrote:
> On Fri, 24 Apr 2009, Frans Pop wrote:
> > Looks like you're using an initramfs initrd and the bnx2 module is
> > getting loaded at that stage. Have you checked that the bnx firmware
> > file is included in your initramfs?
>
> According to his config he has:
>
> 	CONFIG_FIRMWARE_IN_KERNEL=y
>
> which should make all initrd issues pointless - the firmware should be
> included in the kernel directly.

IIUC only if the driver is compiled in, not if it's modular.
