Return-Path: <linux-kernel-owner+w=401wt.eu-S1031565AbXEHTcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031565AbXEHTcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031505AbXEHTb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:31:58 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:35098 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967821AbXEHTb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:31:57 -0400
Date: Tue, 8 May 2007 14:31:27 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Ismail =?ISO-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: Timur Tabi <timur@freescale.com>, Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Kconfig warnings on latest GIT
Message-Id: <20070508143127.38fafa3c.kim.phillips@freescale.com>
In-Reply-To: <200705080004.14570.ismail@pardus.org.tr>
References: <200705080004.14570.ismail@pardus.org.tr>
Organization: Freescale Semiconductor
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 00:04:14 +0300
Ismail Dönmez <ismail@pardus.org.tr> wrote:

> 
> drivers/net/Kconfig:2279:warning: 'select' used by config symbol 'UCC_GETH' 
> refers to undefined symbol 'UCC_FAST'

looks like this introduces the error:

commit 7d776cb596994219584257eb5956b87628e5deaf
Author: Timur Tabi <timur@freescale.com>
Date:   Mon Mar 12 15:40:27 2007 -0500

    [POWERPC] QE: automatically select QE options

    Change the Kconfig files so that the Freescale QE options are automatically
    selected if a QE device is selected.  Previously, you'd need to manually
    select UCC_FAST if you want any "fast" UCC devices, such as Gigabit Ethernet
    Now, the QE Gigabit Ethernet option is always available if the device has a
    QE, and UCC_FAST is automatically enabled.  A side-effect is that the
    "QE Options" menu no longer exists.

    Signed-off-by: Timur Tabi <timur@freescale.com>
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

cc:ing authors, fti.

Kim
