Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYE3V2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYE3V2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYE3V2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:28:45 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:52502 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbYE3V2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:28:44 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] kaweth: use request_firmware()
Date: Fri, 30 May 2008 23:02:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Michael Zappe <zapman@interlan.net>,
       Stephane Alnet <stephane@u-picardie.fr>,
       Brad Hards <bhards@bigpond.net.au>
References: <1211708969@pmac.infradead.org> <FD896A2C-277F-45CF-AE26-E2E29DA8093F@holtmann.org> <20080530164842.31b23848@core>
In-Reply-To: <20080530164842.31b23848@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805302302.27890.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 30. Mai 2008 17:48:42 schrieb Alan Cox:
> > we tried to not put that policy into the drivers and I was looking  
> > over this, but in the meantime driver slipped past me and made it in.  
> > We should not do this at all and if people wanna have this, then they  
> > should solve this within udev.
> 
> Then you arrived at the party a year too late. The format name/firmware
> is commonly used all over the kernel. How that maps to a file or
> directory is indeed a matter for udev, but there is already a
> heirarchical namespace and pretending otherwise won't help.

If that is supposed to be constructed from the driver/file pair,
it is a good idea, but would argue against hardcoding it in the source.

	Regards
		Oliver
