Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965260Ab0BZQLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:11:05 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:60575 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965245Ab0BZQLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:11:00 -0500
Date: Fri, 26 Feb 2010 19:10:59 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Sandeep Gopalpet <Sandeep.Kumar@freescale.com>, davem@davemloft.net
Subject: Re: Gianfar driver failing on MPC8641D based board
Message-ID: <20100226161058.GA22954@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <4B86A97E.6050509@ge.com>
 <20100225165141.GA9686@oksana.dev.rtsoft.ru>
 <20100225174935.GA32370@oksana.dev.rtsoft.ru>
 <7d1d9c251002251653n6473f01ex2d43933ec6aa010b@mail.gmail.com>
 <20100226031452.GA11319@oksana.dev.rtsoft.ru>
 <4B87B937.6010204@ge.com>
 <20100226143532.GA31622@oksana.dev.rtsoft.ru>
 <4B87E01E.4070704@windriver.com>
 <4B87E662.3080106@ge.com>
 <4B87E9EF.3010604@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B87E9EF.3010604@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 03:34:07PM +0000, Martyn Welch wrote:
[...]
> Out of 10 boot attempts, 7 failed.

OK, I see why. With ip=on (dhcp boot) it's much harder to trigger
it. With static ip config can I see the same.
