Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYLFQ4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYLFQ4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYLFQ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:56:38 -0500
Received: from corega.com.ru ([195.178.208.66]:60208 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYLFQ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:56:37 -0500
Date: Sat, 6 Dec 2008 19:56:35 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081206165634.GA2516@ioremap.net>
References: <20081205181610.518ecd13@lxorguk.ukuu.org.uk> <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com> <20081205192755.GA27712@ioremap.net> <20081205193432.290a6f1a@lxorguk.ukuu.org.uk> <20081205211223.GA8075@ioremap.net> <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com> <20081205212428.GB8075@ioremap.net> <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com> <20081206160927.GA498@ioremap.net> <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 05:16:06PM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
> So the loop is probably a modprobe itself that tries to access
> /dev/console. Is there a different argument for the very first
> modprobe which is called? Which may be the one that triggers the loop.

Hard to tell, I did not see anything but modprobe before and after
runaway loop message, but it could be missed though, I will tell
for sure only this Monday.

-- 
	Evgeniy Polyakov
