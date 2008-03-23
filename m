Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbYCWRzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbYCWRzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 13:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYCWRzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 13:55:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYCWRzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 13:55:07 -0400
Message-ID: <47E69974.5000208@zytor.com>
Date: Sun, 23 Mar 2008 10:55:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "John T." <j.thomast@yahoo.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <578664.95535.qm@web45709.mail.sp1.yahoo.com>
In-Reply-To: <578664.95535.qm@web45709.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John T. wrote:
> 
> OK, let's see if I can answer this.
> 
> Vi has 32 years of ESC key use tradition which doesn't play
> well with "meta sends ESC".
> 
> Even though "meta sets 8th bit" is "broken" in your point-of-view,
> that didn't stop it from being used all these years. The fact
> that it maps into real characters is not a problem if you can just
> use a CTRL-V equivalent in bash or vim.
> 
> Furthermore, it is an _option_. No one is obliged to use it.
> So it's a question of:
> 
> .. _forcing_ the end of "meta sets 8th bit"
> .. leaving things the way they are, and have them keep working,
>  as xterm did.
> 
> So guess we should fix xterm too?
> 
> I think you're exagerating.
> 

Hardly.  vim clearly can deal with the ESC-is-prefix issue anyway, since 
otherwise it wouldn't be able to use arrow keys.

That being said, quite frankly, *both* Meta key conventions are 
incredibly broken.

What I would much prefer is to see would be a brand new convention where 
different keys (Ctrl, Meta, Super, Hyper, Alt or even in some cases 
Shift) issues a unique prefix which doesn't conflict with anything else. 
  Emacs has tried to promote such a convention of the format
<CAN> @ <bucky> <keystroke> which is a lot better, although it's a bit 
Emacs-centric (using <CAN> / ^X as the initial character is not really a 
very good choice.)

The best probably would be to introduce an escape code, along the lines 
of other escape codes in the terminal interfae.

	-hpa
