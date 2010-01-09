Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493Ab0AIU0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0AIU0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 15:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948Ab0AIU0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 15:26:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33218 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751804Ab0AIU03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 15:26:29 -0500
Date: Sat, 9 Jan 2010 20:30:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Paul G. Allen" <pgallen@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Serial Performance
Message-ID: <20100109203022.3e506602@lxorguk.ukuu.org.uk>
In-Reply-To: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
References: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am wondering, have there been any performance tests comparing Linux
> serial IO to Windows and what was the result? Is it a problem in the

Our peak throughput is about 40-50Mbits/second

> comm API (e.g. - the Windows DLL having better performance than the
> Linux .so)? Is it a problem in the Linux serial driver itself? Is
> there something I can/need to do on Linux to tweak the driver and make
> it faster?

You probably need to ask a java list and profile it below the java level
to get answers here. It's possible there are small performance
differences between Linux and Windows at 115,200 but I'd not expect any
except maybe in latency and then only small ones.

The number of java experts on the kernel list is quite small I'm afraid.
