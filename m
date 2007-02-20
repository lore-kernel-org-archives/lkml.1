Return-Path: <linux-kernel-owner+w=401wt.eu-S1161088AbXBTX0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161088AbXBTX0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161090AbXBTX0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:26:24 -0500
Received: from tirith.ics.muni.cz ([147.251.4.36]:55206 "EHLO
	tirith.ics.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161088AbXBTX0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:26:23 -0500
Date: Wed, 21 Feb 2007 00:26:33 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git patches] libata ACPI support
Message-ID: <20070220232633.GA3598@mail.muni.cz>
References: <20070220214716.GA3690@mail.muni.cz> <45DB74D9.206@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45DB74D9.206@garzik.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (tirith.ics.muni.cz [147.251.4.35]); Wed, 21 Feb 2007 00:26:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 05:23:21PM -0500, Jeff Garzik wrote:
> >introducing SATA ACPI does not work for me (I've filled the bug
> >report: http://bugzilla.kernel.org/show_bug.cgi?id=8046) beside those error
> >messages, IDE performance is decreased. libata.noacpi=1 option works ok but
> >the performance is still slightly degraded (about 10%).
> 
> Does performance come back if you also use acpi=off ?

It does not.

With 2.6.20-git15, hdparm -t /dev/sda says 28MB/s, 
with 2.6.20, hdparm -t /dev/sda says 32MB/s.

-- 
Luká¹ Hejtmánek
