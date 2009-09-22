Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZIVEmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZIVEmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 00:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZIVEmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 00:42:12 -0400
Received: from smtpauth18.prod.mesa1.secureserver.net ([64.202.165.31]:49616
	"HELO smtpauth18.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751209AbZIVEmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 00:42:12 -0400
Date: Tue, 22 Sep 2009 16:41:04 +1200
From: Kelly Bowa <kbpm@tuxedu.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.31] Memory leak in SCSI initialization?
Message-ID: <20090922044104.GB7755@tuxedu.home>
Mail-Followup-To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp) wrote:
> Hello.
> 
> I can see below message appears for 15 times in
> /sys/kernel/debug/kmemleak after processing /init inside initramfs.
...
Hi Tetsuo,

I can confirm this on 2.6.31-rc9 with following trace:
http://www.tuxedu.org/people/kbpm/bad/scsi-trace

Thanks,
kbpm
