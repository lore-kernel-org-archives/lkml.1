Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZF3Mct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZF3Mct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZF3Mcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:32:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37943 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179AbZF3Mcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:32:42 -0400
Date: Tue, 30 Jun 2009 13:33:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] make execve(NULL) re-execute current binary
Message-ID: <20090630133354.518be0ec@lxorguk.ukuu.org.uk>
In-Reply-To: <1158166a0906300510w5b03adb9k7368a049a2bec263@mail.gmail.com>
References: <200906300003.39440.vda.linux@googlemail.com>
	<20090629232733.7ae52b7f@lxorguk.ukuu.org.uk>
	<1158166a0906300510w5b03adb9k7368a049a2bec263@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The behavior of execve(NULL) is not undefined. It returns EFAULT.
> The idea was that application will do:

That depends what you have mapped at address zero and if your platform
supports EFAULT reporting for address zero. It isn't a reliable
assumption.

Alan
