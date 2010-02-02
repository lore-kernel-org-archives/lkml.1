Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0BBPZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:25:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:56223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab0BBPZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:25:16 -0500
Message-ID: <4B6843D7.9090602@suse.cz>
Date: Tue, 02 Feb 2010 16:25:11 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] platform_driver_register: warn if probe is in	.init.text
References: <20100122173846.GA11057@suse.de> <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de> <87y6jnw6qa.fsf@devron.myhome.or.jp> <20100126084741.GC20792@pengutronix.de> <20100128011403.GB24068@kroah.com> <20100130204425.GA16345@pengutronix.de> <20100131160213.GA14896@merkur.ravnborg.org> <20100131201300.GA20892@pengutronix.de>
In-Reply-To: <20100131201300.GA20892@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.1.2010 21:13, Uwe Kleine-König wrote:
> Hello,
> 
>> Michael is handling kbuild stuff now and that may include modpost stuff.
>> So added Michael - then you guys can decide way forward.
> Then the F: patterns for kbuild in MAINTAINERS should be extended.

Well, modpost is kind of grey zone between module support (Rusty, whom
you already included) and kbuild (me, who added a subject filter for
"modpost" and is happy). This series is more kbuild related (it does not
affect the module loader) and it looks ok to me, so I'll pull it.

>  
>> The modpost patches looks OK at a quick view.
>> You can consider adding:
>>
>> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks, I added your ack to the merge commit.

Michal
