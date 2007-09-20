Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbXITH0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbXITH0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbXITHZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:25:54 -0400
Received: from sslsrv.de ([62.75.159.123]:56051 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbXITHZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:25:53 -0400
Message-ID: <60355.193.171.152.61.1190273138.squirrel@webmail.marek.priv.at>
In-Reply-To: <20070920070114.GA8580@uranus.ravnborg.org>
References: <200709181714.34035@x5> <200709191443.24158@x5>
    <20070919085032.dd5c1732.randy.dunlap@oracle.com>
    <200709191817.51921@x5> <20070919180544.GA11860@c2.user-mode-linux.org>
    <39168.193.171.152.61.1190267089.squirrel@webmail.marek.priv.at>
    <20070920070114.GA8580@uranus.ravnborg.org>
Date: Thu, 20 Sep 2007 09:25:38 +0200 (CEST)
Subject: Re: UML dead with current -git?
From: "Philipp Marek" <philipp@marek.priv.at>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Jeff Dike" <jdike@addtoit.com>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6-4.fc1.1.legacy
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> > It doesn't handle O= directories...
>> Sorry, I don't understand you. What are "0=" directories?
>
> When building a kernel you can specify an other output directory
> so you do not mix up your source tree with generated files.
> To do so do like this:
>
> Prepare the stuff:
> mkdir ~/kernel
> cp .config ~/kernel
> make mrproper
>
> And then build the kernel:
> make O=~/kernel
Oh yes ...  thats the character 'o', not the number zero ...
Sorry, changing the font shows that :-)


Yes, that's right. Wouldn't $(srctree) help? That's defined just above, so
should be fine.


Regards,

Phil


-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!
