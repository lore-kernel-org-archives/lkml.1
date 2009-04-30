Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbZD3O0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbZD3O0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762497AbZD3O0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:26:12 -0400
Received: from mailout.ijneb.com ([212.13.201.26]:30503 "EHLO
	metheny.ijneb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761492AbZD3O0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:26:11 -0400
Date: Thu, 30 Apr 2009 15:26:08 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: Willy Tarreau <w@1wt.eu>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: splice() on two pipes
In-Reply-To: <20090430045645.GF570@1wt.eu>
Message-ID: <alpine.BSO.2.00.0904301452030.5232@zrgural.vwaro.pbz>
References: <20090429103308.GA23684@squirrel.roonstrasse.net> <87my9zpjqe.fsf@basil.nowhere.org> <20090429194254.GA7956@squirrel.roonstrasse.net> <20090430045645.GF570@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Willy Tarreau wrote:

> BTW, I like your test program. Simple and easy. I have completed it to 
> test tcp and udp, you can find it attached.

I think the shown ability to splice to a unix socket may be misleading. 
Can someone offer some insight to my previous post (22nd April, "splice() 
on unix sockets")? Does splice to a unix socket actually result in zero 
copy?

   $ ./test_splice
   in\out  pipe    reg     chr     unix    tcp     udp
   pipe    no      yes     yes     yes     yes     yes
   reg     yes     no      no      no      no      no
   chr     no      no      no      no      no      no
   unix    no      no      no      no      no      no
   tcp     yes     no      no      no      no      no
   udp     no      no      no      no      no      no

Thanks

-- 
Mark
