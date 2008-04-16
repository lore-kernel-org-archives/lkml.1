Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYDPFip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYDPFip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 01:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYDPFif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 01:38:35 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:35919 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbYDPFif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 01:38:35 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
Subject: Re: ehci-hcd affects hda speed
Date: Wed, 16 Apr 2008 07:38:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200804152202.18358.oliver@neukum.org> <alpine.LFD.1.10.0804160039420.4157@nev.ubzr>
In-Reply-To: <alpine.LFD.1.10.0804160039420.4157@nev.ubzr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804160738.13437.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 15. April 2008 22:41:19 schrieb Lev A. Melnikovsky:
> 
>   On Wed, 16 Apr 2008 at 12:02am, Oliver Neukum wrote:
> 
> ON> Am Dienstag, 15. April 2008 21:56:24 schrieb Lev A. Melnikovsky:
> ON> > The oddest peculiarity for me is the hysteretic difference between #1 and 
> ON> > #3 states. I mean experimental data (hda throughput) depends not on the 
> ON> > state (hardware/loaded modules), but on the path we followed.
> ON> 
> ON> Did you compile with CONFIG_USB_SUSPEND?
> 
> # CONFIG_USB_SUSPEND is not set
> 
> Does this explain something?

EHCI should not scan an empty async. However this manufacturer
has shown a liberal attitude about conforming with specifications.
If the root hub is suspended, it can't do DMA. So it might help.

	Regards
		Oliver
