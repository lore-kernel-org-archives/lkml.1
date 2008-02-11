Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbYBKUkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbYBKUkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYBKUk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:40:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:41744 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755080AbYBKUkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:40:23 -0500
Date: Mon, 11 Feb 2008 21:40:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Abel Bernabeu <abelbg@m2grp.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] Elf loader crash while zero-filling .bss
In-Reply-To: <47B0B1AB.3020203@zytor.com>
Message-ID: <Pine.LNX.4.64.0802112137360.30955@jikos.suse.cz>
References: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com> 
 <15577be70802111032l6ea6d2fagba2da4462c739d66@mail.gmail.com> 
 <Pine.LNX.4.64.0802111944220.7699@twin.jikos.cz>
 <15577be70802111111x36f61433p321e5b8175a13d08@mail.gmail.com>
 <Pine.LNX.4.64.0802112026470.30955@jikos.suse.cz> <47B0B1AB.3020203@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, H. Peter Anvin wrote:


> > Now, the question is whether it is valid for ELF binary to not have the end
> > of .bss section (if present at all) not page-aligned.
> Why wouldn't it be?  It would, however, be valid to the kernel to round it up
> to the next boundary.

I wasn't immediately sure if there is nothing in ELF specification that 
would forbid that.

Then I think that Abel's patch is correct.

-- 
Jiri Kosina
SUSE Labs
