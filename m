Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbXGHJqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbXGHJqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 05:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXGHJqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 05:46:17 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:29951 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753322AbXGHJqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 05:46:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=d8fHD5E6dlyIAzGpAAlsR4QahLX8p/vLH5eniLU13tf+DI7aNt73T42DJghctsc/qPAdz03HvkUN3s9e6ZVvcVyFrhl72srVU6kWqul4LhQ9CVMtPuQPPmr7h5slGMf0KOYcB/5GlT1bjaZoYyS7EqH+8g2JxwEGonM4Ceh0CfQ=  ;
X-YMail-OSG: yPN05cMVM1niSSwdGtFivGxe5St6bSgLODGS0LC9RD5LAU.pYB8JWt7f47UHSnvYqT6jzwtYJw--
Message-ID: <4690B263.3030002@yahoo.com.au>
Date: Sun, 08 Jul 2007 19:46:11 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: maps2-move-the-page-walker-code-to-lib.patch
References: <1183873796.6005.269.camel@localhost.localdomain>
In-Reply-To: <1183873796.6005.269.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Matt wrote:
> 
>>This lets it get shared outside of proc/ and linked in only when needed.
> 
> 
> Erk, this really belongs in the mm dir.  You can use "lib-y +=
> pagewalk.o" there, and it seems to work as well as doing it in lib.

+1 from me, again :)

-- 
SUSE Labs, Novell Inc.
