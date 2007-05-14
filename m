Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbXENDY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbXENDY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 23:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbXENDYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 23:24:50 -0400
Received: from web36704.mail.mud.yahoo.com ([209.191.85.38]:25026 "HELO
	web36704.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754958AbXENDYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 23:24:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=A+zgcR6PhB4Jj4cEZjrCfM73wkKfX0Z9NpgQl8cHvQHVo3hoU/gJ3E4eD4psyoyvufW6RW5A7N59sMyyQXqDrL7AGtUpt/FyJhquzg7t7yJL7GCVQZyKVQByjJICx5U/HADPYDPrY+QPXBBiWgw9rl0A1Z9X6ApkOWYA3nyhff4=;
X-YMail-OSG: V4nGrfgVM1notYJxBFd6VfLdwO8r25TAtXrEVRLDw_vzoEnoGlPUKPVz6XmGRjvFbmUBWUrz8Gxz7QrBceNrn2idQ3UEzVdH6RzS
Date: Sun, 13 May 2007 20:24:48 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Pierre Ossman <drzeus@drzeus.cx>
In-Reply-To: <20070513223207.GA3265@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <519259.3474.qm@web36704.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have any particular need in multithreaded wq, but I do need it freezeable. Freezeability
simplifies things quite a lot. This is ok with me:

> -#define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
> +#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)



 
____________________________________________________________________________________
8:00? 8:25? 8:40? Find a flick in no time 
with the Yahoo! Search movie showtime shortcut.
http://tools.search.yahoo.com/shortcuts/#news
