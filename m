Return-Path: <linux-kernel-owner+w=401wt.eu-S1030317AbXDCPRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030317AbXDCPRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030319AbXDCPRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:17:23 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37734 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030317AbXDCPRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:17:23 -0400
Date: Tue, 3 Apr 2007 08:18:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Carlo Florendo <subscribermail@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel source dependency
Message-Id: <20070403081853.6590ef84.randy.dunlap@oracle.com>
In-Reply-To: <46120EBE.8080705@gmail.com>
References: <46120EBE.8080705@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 16:22:22 +0800 Carlo Florendo wrote:

> Hello,
> 
> I'm not sure whether a fix is necessary for the following scenario.
> 
> The kernel configure target "make menuconfig" requires ncurses.   FWIW, it
> could probably be better if the error message would indicate that that
> ncurses is necessary for "make menuconfig" to run and that the user could
> be prompted to install the package.

Hi,
Without ncurses installed, you should see these messages:

	echo " *** Unable to find the ncurses libraries."
	echo " *** make menuconfig require the ncurses libraries"
	echo " *** "
	echo " *** Install ncurses (ncurses-devel) and try again"
	echo " *** "

Do you not see them?  or do you need something different?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
