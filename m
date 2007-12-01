Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbXLAUn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbXLAUn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbXLAUnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:43:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45947 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbXLAUnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:43:50 -0500
Date: Sat, 1 Dec 2007 12:42:42 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Joshua Hudson" <joshudson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Executable file format, locating stack?
Message-ID: <20071201124242.63110111@laptopd505.fenrus.org>
In-Reply-To: <bda6d13a0712011009k13fe4e41u46dcdecd26fca037@mail.gmail.com>
References: <bda6d13a0712011009k13fe4e41u46dcdecd26fca037@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 10:09:28 -0800
"Joshua Hudson" <joshudson@gmail.com> wrote:

> Is there an executable file format that can specify things like where
> the stack ends up?
> Yes, I really do care. I want to put the stack at the top of virtual
> address space rather than randomized.

just set the personality with setarch if you don't want randomisation.

Why is it that you can't cope with randomization? You'll have SOME
randomziation no matter what because each glibc compile will have a
slightly different footprint on the stack before your app gets to it,
as do the various environment variables and kernel AT_ variables.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
