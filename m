Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbXGXVwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbXGXVwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbXGXVw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:52:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbXGXVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:52:25 -0400
Message-ID: <46A6748E.1020305@zytor.com>
Date: Tue, 24 Jul 2007 14:52:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, Egmont Koblinger <egmont@uhulinux.hu>
Subject: Re: console UTF-8 fixes
References: <20070724214736.GL3700@interface.famille.thibault.fr>
In-Reply-To: <20070724214736.GL3700@interface.famille.thibault.fr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault wrote:
> Hi,
> 
> Egmont got some UTF-8 fixes in mainline, Andrew Morton suggested it
> might be a good time to remember about bug 7746 Support for unicode dead
> keys: http://bugzilla.kernel.org/show_bug.cgi?id=7746 :
> 
> « Quoting a mail from Vojtech Pavlik:
> 
> "Several languages (polish, czech, slovak, ...) use dead keys (keys that
> don't do anything per se, but put an accent on the next letter). And
> now almost everyone is switching to unicode. And Linux kernel doesn't
> support unicode for dead keys. This means trouble."
> (full mail at
> http://www.ussg.iu.edu/hypermail/linux/kernel/0405.3/1387.html)
> 
> And indeed, see http://bugs.debian.org/404503
> 
> There is a more recent patch proposed on
> http://www.ussg.iu.edu/hypermail/linux/kernel/0503.2/1723.html
> 
> Is there any objection to the proposed way? (extending the internal
> type, and add a new ioctl for uploading unicode dead keys). »
> 

Makes sense to me.

	-hpa
