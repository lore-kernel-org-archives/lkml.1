Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZGMUK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZGMUK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbZGMUK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:10:58 -0400
Received: from smtp.df.ru ([195.42.160.16]:52780 "EHLO smtp.df.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970AbZGMUK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:10:58 -0400
Date: Tue, 14 Jul 2009 00:11:47 +0400
From: Alexey Vlasov <renton@renton.name>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Counters in df, du
Message-ID: <20090713201147.GD5569@beaver.vrungel.ru>
References: <20090713081106.GA5569@beaver.vrungel.ru> <87fxd19cfq.fsf@basil.nowhere.org> <20090713113252.GB5569@beaver.vrungel.ru> <3e8340490907130654i3d00aa6dt9118004c2fd94689@mail.gmail.com> <20090713195558.GC5569@beaver.vrungel.ru> <3e8340490907131258g35c422ebm5a3147f9a80fd6eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e8340490907131258g35c422ebm5a3147f9a80fd6eb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 03:58:36PM -0400, Bryan Donlan wrote:
> 2009/7/13 Alexey Vlasov <renton@renton.name>:
> > # lsof -n /tmp | awk '/deleted/ {if ($7 != 0) print$0}'
> >
> > mysqld š š22905 š š š š š š š š š š š š šmysql š š6u š REG
> > 0,13 š š20 663938322 /tmp/ib1oZTSZ (deleted)
> > mysqld š š22905 š š š š š š š š š š š š šmysql š š8u š REG
> > 0,13 84773 663938424 /tmp/ibRcarbD (deleted)
> >
> > # df -h /tmp
> > Filesystem š š š š š šSize šUsed Avail Use% Mounted on
> > tmpfs š š š š š š š š 4.1G š3.4G š630M š85% /tmp
> 
> Are those the only two results? That should only be adding up to ~84kb
> of space...

Yes, only two lines where the 7-th column isn't equal to 0

-- 
BRGDS. Alexey Vlasov.
