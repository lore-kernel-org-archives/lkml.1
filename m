Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbXHGG5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbXHGG5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbXHGG5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:57:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:29904 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbXHGG45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NZnjDOx8q6+WvI76tPkUpV1H0b9HmUJGl413h6Uop3qU0sga+cZ1+NeOldx+JdiDAhkz4QN8z2XfgaA6C2nNbnQAdI1zhukQqo1HxYcSDz/n6BFKKEmiHgVI6lXRJkymyvdnpt0UC8DO4ypAAi3doF3MEkpN+9G9lWl1/ypPUwY=
Message-ID: <46B817AB.30105@gmail.com>
Date: Tue, 07 Aug 2007 15:56:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Michael Sedkowski <sedmich@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>	 <1186411815.4355.7.camel@nx6310>	 <20070806150159.GC31615@khazad-dum.debian.net>	 <200708061732.03425.rjw@sisk.pl>  <46B75459.9020204@gmail.com>	 <1186424492.4355.1.camel@nx6310>  <46B76BBC.9010107@gmail.com> <1186438698.4402.6.camel@nx6310>
In-Reply-To: <1186438698.4402.6.camel@nx6310>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Sedkowski wrote:
> Dnia 07-08-2007, Wt o godzinie 03:43 +0900, Tejun Heo napisał(a):
>> Does emergency unload count increase
>> after each power down? 
> 
> I think I got it.
> Using smartctl I've done a test and shut down, then repeted the test.
> The only values that where diffrent are temperatures and
> Hardware_ECC_Recovered which rised by 6 points.
> However I have no idea which of those is the "emergency count"...
> Full results in attachment.
> 
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       388

I think this is the one.  You can test it by forcefully powering off the
machine (press power button for several secs or disconnect AC and
battery) and see whether the count increases.

-- 
tejun
