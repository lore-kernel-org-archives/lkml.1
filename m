Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXFOTT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXFOTT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXFOTTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:19:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:52469 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXFOTTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kh13tyU0MmBK1TzpchPaoy5I8+2nmOGUQyfydhjn7XckgmBL/OUCscMkdqmD7T8GNMzx60qP69k49P74UN2UU+Yi2eAEEA5jFxpeyH0d8X5cXbwfkFU13RBVkxDSYAGYRrzGwPYWV7uWRUiUGaifmommMP6SejnZCTvrbR5l7e0=
Date: Fri, 15 Jun 2007 23:18:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       dave young <hidave.darkstar@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
Message-ID: <20070615191804.GC8151@cvg>
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <20070615110326.b0762b7a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Engelhardt - Fri, Jun 15, 2007 at 09:10:49PM +0200]
| 
| On Jun 15 2007 11:03, Randy Dunlap wrote:
| >> 
| >> "use tabs for indents and spaces for alignment"
| >> 
| >> If that means you need to use two dozen spaces, then so be it.
| >
| >I don't think that's what that rule means, but I didn't write it,
| >so I'm not absolutely sure about it.
| >
| >but we know that tab stops are every 8th character, not 4 :)
| 
| Hardly.
| 
| 
| 
| 
| 	Jan
| -- 
| 

Jan, as I see from CodingStyle:

	"Tabs are 8 characters, and thus indentations are also 8 characters."

Actually it would be perfect to get strict rules also for math. and log.
operators being splitted on several lines:

	if (long_name_a || long_name_b ||
	    long_name_c)

		or

	if (long_name_a || long_name_b
	    || long_name_c)
	
	
	a = b + c + d + e +
	    f;

		or

	a = b + c + d + e
	    + f;


		Cyrill

