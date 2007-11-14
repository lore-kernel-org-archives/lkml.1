Return-Path: <linux-kernel-owner+w=401wt.eu-S1761161AbXKNDy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761161AbXKNDy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXKNDyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:54:46 -0500
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:20675 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754877AbXKNDyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:54:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WTK/OYTGeKY+Whp1kpg7a+QCLa2ZKZzxkegzlGSWhVfjxk2v2+FVxd/4u5rlT7JGNsgwRihT5jfGW6PVoz6MeeWArafxoCgXpCXn0QJ/tk5BK8vcrXQ5JFfJbLCSs4V2xZy+aULvxSRNI0RlHkfMxoko3ICBopgxBuYYd1cXfbo=  ;
X-YMail-OSG: 3hMI..cVM1lgnyIHE_NwCkjF9MNRB5bt_lmEQplmpFI.d5T4o1Jk28K2h8_njThgL5tDEpY1iA--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 13 Nov 2007 19:28:14 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <f17812d70711131700n74236a8naa6dbfc5cb62e42d@mail.gmail.com> <f17812d70711131702m4315a1f3ia16e1d0fedf30825@mail.gmail.com>
In-Reply-To: <f17812d70711131702m4315a1f3ia16e1d0fedf30825@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131928.14782.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, eric miao wrote:
> 
> so that requested will always be used, only *requested_str will be used
> for DEBUG_FS tracking assistance
> 
> Subject: [PATCH 2/5] define gpio_chip.requested_str as a debugfs tracking string

Doesn't seem unreasonable, since the extra cost is only
one bit per GPIO (and that would be paid only when debugfs
is available).  What can I say ... I'd rather not pay the
extra memory space.  :)

