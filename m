Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbXJCTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbXJCTNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbXJCTNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:13:08 -0400
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:34978 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXJCTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:13:07 -0400
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: MSI: Use correct data offset for 32-bit MSI in read_msi_msg()
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
References: <87abr0oyj4.fsf@shaolin.home.digitalvampire.org>
	<m1ir5ocaxr.fsf@ebiederm.dsl.xmission.com>
From: Roland Dreier <roland@digitalvampire.org>
Date: Wed, 03 Oct 2007 12:13:41 -0700
In-Reply-To: <m1ir5ocaxr.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's message of "Wed, 03 Oct 2007 12:25:36 -0600")
Message-ID: <874ph8ovtm.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > While reading the MSI code trying to find a reason why MSI wouldn't
 > > work for devices that have a 32-bit MSI address capability, I noticed
 > > that read_msi_msg() seems to read the message data from the wrong
 > > offset in this case.
 > 
 > Doh!  Sorry about that.

Doesn't matter, it wasn't the bug hitting me anyway :) the IRQ never
got affinity changed so read_msi_msg() never even got called.

I'm starting to think that Intel 945GM graphics just has a busted MSI
implementation, although there may be a bug hiding in the Linux code
that I'm not seeing.

 - R.
