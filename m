Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbZCWIwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbZCWIwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbZCWIwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:52:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44381 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbZCWIwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=rRrazOym0fpTAauXxsiZN/XujwntPv8HQao0lx3SYEgAiyFx86cpX9uADCnbZz6FH3
         wf528QXcRm2hqZ9x+TD+U3tAoz+3diDMLNLBmImukmEkJ40VUQ3pvxjd+HMk6xuwIZ9N
         3azJofHcosgY2ZCF57ZHe92va4KSCiYUj0ECM=
MIME-Version: 1.0
In-Reply-To: <2d05c4580903230151n20c8fc7kb47a5e2bb2480591@mail.gmail.com>
References: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
	 <alpine.LNX.2.00.0903222124580.7175@swampdragon.chaosbits.net>
	 <2d05c4580903230151n20c8fc7kb47a5e2bb2480591@mail.gmail.com>
Date: Mon, 23 Mar 2009 09:52:19 +0100
Message-ID: <2d05c4580903230152q24c1625bu3b13a8a3c0fd3ce0@mail.gmail.com>
Subject: Re: Test some kernel feature without recompile
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well it looks like I didn't read about "make" command a lot :)
This is what I found :

--------------------------------------------------------------------------------------------------------------------------------------------------------
| Once a suitable Makefile exists, each time you change some source
files, this simple shell command:
|
|    make
|
| suffices to perform all necessary recompilations. The make program
uses the makefile data base and
| the last-modification times of the files to decide which of the
files need to be updated. For each of those
| files, it issues the commands recorded in the data base.
--------------------------------------------------------------------------------------------------------------------------------------------------------

So this is what I would (will) do if I want to debug, change or add
some kernel feature and don't want to wait a
lot of time every time :) :

Build version of kernel that has minimum modules (and other stuff) to
run your machine (unchecked things in
.config file will decrease time) and when work on some feature, then
add just stuff you wanna debug or
change and then run

make

thanks,

dragoslav
