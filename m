Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbZLHH1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbZLHH1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZLHH1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:27:21 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:43514 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbZLHH1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=ldCjAY3Y9IdUujuuHcAn3vcXEUWtNnXl7HOsx9S1I+qMFCRBkCWrTxB0HwEsm8YJyb
         FG5Hge3zWHSlRx9fGEGtfmN0k5doYDMMs92s0ng6TcxrIJoDFLl8FqtV+5nQdQRuGmvf
         +t+gneMvBa6fSfI6Fv9THfUrnnw7UVAAJZkBI=
Subject: Re: [PATCH v8 5/8] Loongson: YeeLoong: add hardware monitoring
 driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20091208070915.GC12264@elf.ucw.cz>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
	 <d8789fa7e97d8a170c4e2516d7ef2d2fbbe42cc6.1260082252.git.wuzhangjin@gmail.com>
	 <20091206084717.GD2766@ucw.cz> <1260147298.3126.2.camel@falcon.domain.org>
	 <20091207080446.GB23088@elf.ucw.cz>
	 <1260178870.9092.34.camel@falcon.domain.org>
	 <20091207094909.GD23088@elf.ucw.cz>
	 <1260183663.9092.51.camel@falcon.domain.org>
	 <20091208070915.GC12264@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Tue, 08 Dec 2009 15:26:50 +0800
Message-ID: <1260257210.3315.63.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 08:09 +0100, Pavel Machek wrote:
> > > > > That's certainly better. But... why not return signed value? Current
> > > > > flowing from the battery is certainly very different from current
> > > > > flowing into it...
> > > > 
> > > > You are totally right ;)
> > > > 
> > > > Just test it, when flowing from the battery, the value is negative, and
> > > > when flowing into the battery, the value is positive, so, no abs()
> > > > needed. thanks!
> > > 
> > > Make it return -value, then. I believe other code uses >0 values for
> > > discharge.
> > 
> > Done, but any document/standard about it?
> 
> Not sure, feel free to patch the documentation, too :-).

Okay, I will send a documentation(as a separate patch) like them:

$ ls Documentation/ABI/testing/sysfs-platform-*
Documentation/ABI/testing/sysfs-platform-asus-laptop
Documentation/ABI/testing/sysfs-platform-eeepc-laptop 

Thanks & Regards,
	Wu Zhangjin

