Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYBSOTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYBSOTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYBSOTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:19:43 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:49120 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbYBSOTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:19:42 -0500
Date: Tue, 19 Feb 2008 14:19:40 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MIPS] Enable the timerfd_*() o32 system calls
Message-ID: <20080219141940.GA14991@linux-mips.org>
References: <1203368557-32356-1-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203368557-32356-1-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 12:02:37AM +0300, Dmitri Vorobiev wrote:

> This patch enables the system calls timerfd_create(), timerfd_settime()
> and timerfd_gettime() for MIPS architecture.
> 
> Please see the following Bugzilla entry for more details:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10038
> 
> This was tested using a Malta 4Kc board in both little-endian and
> big-endian modes. The unit test program is available from the URL
> above.
> 
> Note that only the "o32"-style system calls have been added. This is
> due to the fact that I have no suitable equipment to test the other
> flavors of MIPS ABI.

Thanks.  I added the missing bits for the others ABIs and applied the
combined patch.

  Ralf
