Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbZJJXZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbZJJXZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 19:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZJJXZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 19:25:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38697 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754266AbZJJXZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 19:25:04 -0400
Date: Sun, 11 Oct 2009 00:25:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bernhard Walle <bernhard@bwalle.de>, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] Use vt_get_kmsg_redirect() and
 vt_set_kmsg_redirect()
Message-ID: <20091011002544.32c6f196@lxorguk.ukuu.org.uk>
In-Reply-To: <20091011000632.3148849e@lxorguk.ukuu.org.uk>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
	<1255207870-24496-4-git-send-email-bernhard@bwalle.de>
	<20091011000632.3148849e@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> variable is now function local and the whole pile of stuff you posted
> becomes
> 
> #if defined(CONFIG_VT_CONSOLE)

Umm testing it this seems gcc/ld isn't quite smart enough to get that
right so the function can't be inlined - the rest holds though, it can be
hidden in function just not in the header file.

