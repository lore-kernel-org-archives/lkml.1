Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYHUAuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYHUAuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYHUAt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:49:57 -0400
Received: from khc.piap.pl ([195.187.100.11]:56636 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbYHUAt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:49:57 -0400
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA Kconfig cleanup: sort the driver list and modify some text
References: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com>
	<18598.42334.73411.476062@harpo.it.uu.se>
	<20080816113224.5562a9a6@lxorguk.ukuu.org.uk>
	<5rkha4l846d0benss3hip3nvr0cmnfi1k4@4ax.com>
	<m3vdxvqnbb.fsf@maximus.localdomain>
	<tecpa4928hh8kahc53p019sr7nclg8kbjr@4ax.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 21 Aug 2008 02:49:55 +0200
In-Reply-To: <tecpa4928hh8kahc53p019sr7nclg8kbjr@4ax.com> (Grant Coady's message of "Thu\, 21 Aug 2008 10\:16\:49 +1000")
Message-ID: <m3ljyrqjik.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Coady <grant_lkml@dodo.com.au> writes:

>>How the user compiling the kernel knows what ATA_SFF stands for?
>
> They read the help text :)  

Well, can't say you're wrong...

>>Why not "select ATA_SFF" instead (when any driver using this is
>>selected)?
>
> Because then the driver list is always visible?

And it's IMHO great. Don't you like the full list immediately when
drivers/ata are selected?

> Besides, I don't like the way select locks in stuff at the moment, means 
> you have to turn off every option to get rid of the forced select option 
>  -- I'd rather see turning off a 'select'ed item drop all of its 
> dependencies.  

But it's not a problem with drivers/ata, is it?
Personally I think I'd prefer a dialog box listing dependencies and
asking what to do with that, and other improvements. I guess I should
start hacking kconfig some day.
-- 
Krzysztof Halasa
