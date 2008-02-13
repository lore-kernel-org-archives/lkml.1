Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYBMFMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYBMFMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYBMFMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:12:13 -0500
Received: from web36713.mail.mud.yahoo.com ([209.191.85.47]:31749 "HELO
	web36713.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750927AbYBMFMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:12:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=qjR23XT33W1ehgZWNrfWesHUiRDwydcoIzjiylRGrQ4AJSH0KDoZbqqRAEXG7ZjT6DQxHG4aPXs9WVjoTzHgcIprK9kJg/TNd35Fxk4/rRGANc28KNJodQtWuLUWEEue9mQRYJR911hquoggqZ56d3Wp9SfjaMSQX0Cpxb3JkYU=;
X-YMail-OSG: _Cmlw8EVM1lD95hzgA8jfr5VSmU9b3Xd514lhoqm98Z2qxFqxSi3zA9b6aZBQcpD9BmcoRLS4tyG37.nwxTvcfRjwbRtigZmkyH_jmuJ5I0VB1greiYFoVa.WSwW4w--
Date: Tue, 12 Feb 2008 21:12:08 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] drivers/memstick/host/tifm_ms.c breakage
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080213035659.GQ27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <558635.80940.qm@web36713.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Al Viro <viro@ZenIV.linux.org.uk> wrote:

> readl(sock + ...) that should've been readl(sock->addr + ...)
> 

Thanks. It's a first member in struct, so the problem was just sitting there unnoticed.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

