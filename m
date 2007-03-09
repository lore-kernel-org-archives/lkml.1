Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbXCIIat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbXCIIat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXCIIat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:30:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:55095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXCIIar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:30:47 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Amit Choudhary <amit2030@gmail.com>
Subject: Re: [PATCH] drivers/media/video/se401.c: check kmalloc() return value.
Date: Fri, 9 Mar 2007 09:31:00 +0100
User-Agent: KMail/1.9.1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070308233049.1c1f850c.amit2030@gmail.com>
In-Reply-To: <20070308233049.1c1f850c.amit2030@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703090931.01167.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. März 2007 08:30 schrieb Amit Choudhary:
> Description: Check the return value of kmalloc() in function se401_start_stream(), in file drivers/media/video/se401.c.

Firstly, USB patches to the USB list.

Secondly, you've fixed an oopsable bug, but you also need to check
the return values higher up in the call chain.

	Regards
		Oliver

