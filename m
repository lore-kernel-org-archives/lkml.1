Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYBEOSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYBEOSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 09:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYBEOSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 09:18:43 -0500
Received: from mail.ku-gbr.de ([81.3.11.18]:38987 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751563AbYBEOSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 09:18:43 -0500
Date: Tue, 5 Feb 2008 15:18:41 +0100
From: Konstantin Kletschke <lists@ku-gbr.de>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/1] Nikon D80 usb-storage quirk needs modified, new FW
Message-ID: <20080205141841.GA6791@anita>
Mail-Followup-To: Xavier Bestel <xavier.bestel@free.fr>,
	linux-kernel@vger.kernel.org
References: <20080205124343.GB6638@anita> <1202218008.23816.9.camel@skunk.anacadf.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202218008.23816.9.camel@skunk.anacadf.mentorg.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-02-05 14:26 +0100 schrieb Xavier Bestel:

> > +UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,

> Maybe you should leave them both here.

I suppose the device is checked against a range between
bcdDeviceMin -> bcdDeviceMax to take care of the possibility new
revisions does not need the quirk anymore but all older and bcdDeviceMax
but I found the piece of code not yet. Lets see...

Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
