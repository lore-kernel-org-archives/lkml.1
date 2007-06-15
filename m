Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbXFOJQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbXFOJQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXFOJQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:16:10 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:15091 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbXFOJQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:16:09 -0400
Date: Fri, 15 Jun 2007 11:16:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: dave young <hidave.darkstar@gmail.com>
cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Willy Tarreau <w@1wt.eu>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: coding style
In-Reply-To: <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> 
 <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Cyrill wrote:
>>      err = foo(arg_a, arg_b, arg_c,
>>                arg_d);
  1    23        4

(note: monospace font needed)


Dave wrote:
> The Documentation/CodingStyle says:
>
> Outside of comments, documentation and except in Kconfig, spaces are never
> used for indentation, and the above example is deliberately broken.

Everything is right. The indent only goes from "1" to "2" [see above], 
"3" to "4" is called

	Cyrill wrote:
	>> [spaces only for] alignment

Cyrill wrote:
>> so which one is preferred for the kernel?

err = very_long_function_name(lots_of_arguments,
                              less,
                              less,
                              less,
                              less,
                              even_more_arguments,
                              more_of_this,
                              more_of_that,
                              more,
                              more,
                              more);

IMO, preferred:

err = very_long_function_name(lots_of_arguments, less, less, less, less,
      even_more_arguments, more_of_this, more_of_that, more, more, more);

YMMV.


	Jan
-- 
