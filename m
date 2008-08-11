Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYHKSGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYHKSGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYHKSGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:06:44 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:59650 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYHKSGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:06:43 -0400
Message-ID: <48A07FC1.5040806@keyaccess.nl>
Date: Mon, 11 Aug 2008 20:06:57 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl> <20080811164508.GA18969@lenovo> <48A074D1.4070803@keyaccess.nl> <20080811174147.GO4524@elte.hu>
In-Reply-To: <20080811174147.GO4524@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-08 19:41, Ingo Molnar wrote:

> * Rene Herman <rene.herman@keyaccess.nl> wrote:

>> Ah, I was unaware of that difference, thank you. Ingo, can you replace  
>> the previous incarnation with this one?
> 
> sure - but some other commits were queued already so i've applied the 
> delta fix below.

Thanks and fine ofcourse but from the Cheats 'R Us GIT handbook, when 
there's n patches on top of the one I want to edit:

$ mkdir tmp
$ git format-patch -o tmp HEAD~n
$ git reset --hard HEAD~n
$ git reset --soft HEAD^
<fix>
$ git commit -a -c ORIG_HEAD
$ git am tmp/*
$ rm -rf tmp

Just in case someone finds it interesting... :-)

Rene.
