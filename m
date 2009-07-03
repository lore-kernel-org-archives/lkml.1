Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbZGCUUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbZGCUUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbZGCUT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:19:58 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:45017 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbZGCUT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:19:58 -0400
Date: Fri, 3 Jul 2009 13:20:01 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Andy Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, seiji.munetoh@gmail.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 6/6] tpm_tis: add workarounds for iTPM
Message-ID: <20090703202000.GT28124@hexapodia.org>
References: <1246410255-6839-1-git-send-email-adi@vmware.com> <1246410255-6839-7-git-send-email-adi@vmware.com> <ea8d860a0907031118o7ad0ad4nbe147b32bba57a29@mail.gmail.com> <20090703193340.GA6060@hexapodia.org> <ea8d860a0907031310m5cdd21cy3e86e96c1217676d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea8d860a0907031310m5cdd21cy3e86e96c1217676d@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 10:10:30PM +0200, Marcin Obara wrote:
> 2009/7/3 Andy Isaacson <adi@hexapodia.org>:
> > On Fri, Jul 03, 2009 at 08:18:18PM +0200, Marcin Obara wrote:
> >> Intel iTPM on mobile platforms require this patch.
> >> Intel iTPM on desktop platforms works well without this patch.
> >
> > Please do expand on this -- I don't have access to any iTPM desktop
> > platforms to verify.  Can you provide information on what desktop
> > platforms behave differently so that I can adjust the patch?
> >
> > If you could simply boot a kernel with my patch series on a desktop iTPM
> > and provide the dmesg output, that would be great!
> 
> Intel iTPM with HID:  ICO0102 does not require this patch.
>  (http://lkml.org/lkml/2008/6/28/143)
> 
> Currently, I don't have Q45 platform tested few months ago.

Ah, thanks for the reference.  I may be able to find a Q45+iTPM to test
on.  It would still be very useful to get a dmesg (specifically with
"[PATCH 4/6] tpm_tis: print complete vendor information") to verify the
behavior on the Q45.

-andy
