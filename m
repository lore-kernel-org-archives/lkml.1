Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbXIOQ2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbXIOQ2q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 12:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbXIOQ2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 12:28:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:15680 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbXIOQ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 12:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IZ++2NOa5/U9tCa40ek557cnu2/x6HjxyFiNdywKiJ4kIRx+aB0MEKsbqm3Kbl8Mf+dhxk4CQ6FigrY7Elzh0/az/vkMMZ6ATCl+8zf3ST+okjRS7HlmxsKddD+173bIcRYQBV7HWxJMbNyawZCuKc1YcsmS1J7LW3zh0l1kA/o=
Message-ID: <6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>
Date: Sat, 15 Sep 2007 12:28:36 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: eric.valette@free.fr
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as a module. Works as a module.
Cc: flamingice@sourmilk.net, andreamrl@tiscali.it,
       linux-kernel@vger.kernel.org
In-Reply-To: <46EBEBD2.7060502@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46EBE70C.2040201@free.fr> <46EBEBD2.7060502@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, Eric Valette <eric.valette@free.fr> wrote:
> Eric Valette wrote:
>
> > I can probably take a picture of the backtrace if you want.
>
> Just saw that just above my message in the LKML web interface, someone
> posted a backtrace. Mine is different but at least, we are at least two
> to have the crash.

This is the same thing I said to Paul Rolland, since I think your
problems are the same:
I had this problem as well. It has to do with mac80211, cfg80211 and
the rate control algorithm not initializing early enough in the boot
process. These two patches should fix it:

[PATCH] mac80211: fix initialisation when built-in
http://article.gmane.org/gmane.linux.kernel.wireless.general/5710/match=patch+mac80211+initialisation

[PATCH] cfg80211: fix initialisation if built-in
http://article.gmane.org/gmane.linux.network/71326/match=patch+cfg80211+initialisation

Regards,
Rob
