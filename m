Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZKIAUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZKIAUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 19:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZKIAUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 19:20:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38225 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750851AbZKIAUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 19:20:52 -0500
Date: Mon, 9 Nov 2009 00:22:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091109002232.587c569a@lxorguk.ukuu.org.uk>
In-Reply-To: <ucic9k3e5xq3s3pl2w4mae7a.1257718224112@email.android.com>
References: <ucic9k3e5xq3s3pl2w4mae7a.1257718224112@email.android.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Nov 2009 14:10:24 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Keep in mind that if we end up running that on code with any kind of significant fraction of CMOV it will utterly suck.  

cmov is pretty useless anyway and not a good scheduling choice generally
speaking on a real CPU - so in fact gcc generates very few of them, but a
few is enough to make 686 break on C3
