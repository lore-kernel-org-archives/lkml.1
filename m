Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab0BPSga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:36:30 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:47483 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757051Ab0BPSg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:36:28 -0500
Date: Tue, 16 Feb 2010 21:36:24 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/4] power_supply: bq27x00: remove double endian swap
Message-ID: <20100216183624.GA19677@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1266011806-31747-1-git-send-email-notasas@gmail.com>
 <20100216162223.GA28375@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100216162223.GA28375@enneenne.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 05:22:24PM +0100, Rodolfo Giometti wrote:
> On Fri, Feb 12, 2010 at 11:56:46PM +0200, Grazvydas Ignotas wrote:
> > The bq27x00 registers are little endian, so just read them as such
> > and don't do double endian swap on LE machines.
> > 
> > This also gets rid of strange looking shift that was done after
> > reading 8bit register because endian swap in bq27x00_read() was
> > messing it up.
> > 
> > Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> 
> Acked-by: Rodolfo Giometti <giometti@linux.it>

Patches 1-4 applied. Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
