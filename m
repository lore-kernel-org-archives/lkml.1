Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXECWSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXECWSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 18:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXECWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 18:18:05 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:43671 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbXECWSC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 18:18:02 -0400
In-Reply-To: <200705032103.33809.arnd@arndb.de>
References: <20070503065435.4533.64938.stgit@localhost.localdomain> <200705030948.03984.arnd@arndb.de> <5a7e02f6d1520d8ad02e28ace218981c@kernel.crashing.org> <200705032103.33809.arnd@arndb.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Message-Id: <162630d74e53bc10840b667973122fff@kernel.crashing.org>
Content-Transfer-Encoding: 8BIT
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Date: Fri, 4 May 2007 00:17:39 +0200
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> For example, you could make this
>>>
>>>       compatible = "8xx\0mpc885ads";
>>
>> "mpc885ads-pcmcia\0mpc8xx-pcmcia" or something like that.
>
> Right. I can never remember what goes first...

It doesn't really matter all that much; "correct"
drivers probe for the most specific thing first,
then the next most specific thing they support,
etc.  It is mostly a convention.

The important thing is that you can't just call
yourself "8xx", that is way to generic a name.


Segher

