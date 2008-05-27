Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYE0PDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYE0PDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYE0PDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:03:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbYE0PDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:03:24 -0400
Date: Tue, 27 May 2008 12:03:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, video4linux-list@redhat.com
Subject: Re: [PATCH] dvb-usb/gp8psk.c: return -errno rather than errno
Message-ID: <20080527120303.639a5d04@gaivota>
In-Reply-To: <483BBFD1.3090204@cn.fujitsu.com>
References: <483BBFD1.3090204@cn.fujitsu.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 16:01:21 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> gp8psk_power_ctrl() returns -EINVAL in some failing paths, but
> returns EINVAL in some other paths.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.cn>
> ---
Thanks Li. However, I've committed a few days ago a similar patch from Marcin.


Cheers,
Mauro
