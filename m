Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYJFSVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYJFSVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 14:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYJFSVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 14:21:22 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:33814 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYJFSVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 14:21:21 -0400
X-Greylist: delayed 1795 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 14:21:21 EDT
Date: Mon, 6 Oct 2008 18:54:15 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Jason Vas Dias <jason.vas.dias@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes
 (Re: 2.6.27-rc8+ - first impressions)
In-Reply-To: <200810061915.11936.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0810061852010.10470@ftp.linux-mips.org>
References: <20081005183603.GA3263@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <200810061915.11936.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, Rafael J. Wysocki wrote:

> It appears that the buggy BIOS code has been copy-pasted to the entire range of
> machines, for no good reason.

 The DSDT is specific to the chipset -- the ATI/AMD SB400 southbridge in 
this case -- there is no need to change it for any changes in the 
surrounding hardware components.

  Maciej
