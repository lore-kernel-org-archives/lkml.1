Return-Path: <linux-kernel-owner+w=401wt.eu-S1030876AbXDJPnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030876AbXDJPnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030879AbXDJPnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:43:33 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41470 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030878AbXDJPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:43:31 -0400
Message-ID: <461BB092.3070201@zytor.com>
Date: Tue, 10 Apr 2007 08:43:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Egmont Koblinger <egmont@uhulinux.hu>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com> <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu>
In-Reply-To: <20070410094325.GB9143@uhulinux.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Egmont Koblinger wrote:
> 
> I know that correctly handling all Unicode scripts, including CJK, Hebrew,
> Arabic, Indic are a much more complicated story and it's way beyond the
> scope of kernel. I don't even know whether there's any graphical user-space
> application handling all these issues perfectly. So I really don't want to
> address them.
> 
> I'd like only one small modification: the cursor to jump two columns for CJK
> characters instead of just one. (Either two FFFD's, or rather an FFFD
> followed by a space printed.) This would allow you to edit English words
> within a mixed CJK-English text file. As my experiences show, such a minor
> change in the terminal driver would solve cursor aligning issues in *many*
> cases. With this change the console would still be very-very far from being
> perfect, it just would be simply better in practice.
> 

I don't see the point in dealing with one particular corner case, 
especially a corner case for which font support is inherently impossible.

> Are you still definitely against this change? I see no drawbacks this could
> cause, while it would make the console better in some circumstances. I think
> this is just a small step towards a better console driver.

It's bloat.

	-hpa
