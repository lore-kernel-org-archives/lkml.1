Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbXLUOkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbXLUOkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXLUOkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:40:00 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58922 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbXLUOkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:40:00 -0500
Date: Fri, 21 Dec 2007 09:39:59 -0500
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
Message-ID: <20071221143959.GG2308@csclub.uwaterloo.ca>
References: <ada1w9hyrhn.fsf@cisco.com> <Pine.LNX.4.61.0712201755330.9907@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712201755330.9907@chaos.analogic.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 05:56:19PM -0500, linux-os (Dick Johnson) wrote:
> Okay. Thanks! I need to do that.

On the (now somewhat old) 2.6.18 kernel I use it is an option under
"Processor type and features" called "Use register arguments", but yeah
it isn't an option anymore in new kernels.

As for your argument that it isn't a good idea, well most of the time
the arguments you want to pass to a function are already values you were
just working with to get them ready for the function, so quite likely
they are already in the registers you are worried about having to clear
first.  Add to that the ability of modern x86 CPUs to use rename
registers to fake stack accesses in some cases and the clearing of the
registers become pretty much a non issue, at least that's my
understanding of how things work.

--
Len Sorensen
