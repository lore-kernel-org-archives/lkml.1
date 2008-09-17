Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYIQJ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYIQJ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYIQJ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:59:42 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:45432 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761AbYIQJ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:59:41 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bogus process accounting in 2.6.27-rc5?
Date: Wed, 17 Sep 2008 19:59:27 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <07l1d4lhg4c4ogs3jbv8bnnpqes2367p0d@4ax.com>
References: <888717.44345.qm@web32605.mail.mud.yahoo.com>
In-Reply-To: <888717.44345.qm@web32605.mail.mud.yahoo.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 02:07:24 -0700 (PDT), Martin Knoblauch <knobi@knobisoft.de> wrote:

>Hi,
>
> just saw this one for the first time. Don't think it is easily reproducible. Anything to worry about?
>
>[root@lpsdm52 build]# ps axl | grep pdflush
>1     0  8221     2  20   0     0    0 conges D    ?          0:01 [pdflush]
>1     0 15178     2  20   0     0    0 conges D    ?          0:03 [pdflush]
>1     0 30843     2  20   0     0    0 conges D    ?          0:00 [pdflush]
>1     0 30844     2  20   0     0    0 conges D    ?          0:00 [pdflush]
>1     0 30845     2  20   0     0    0 conges D    ?          0:00 [pdflush]
>1     0 30852     2  20   0     0    0 conges D    ?          0:00 [pdflush]
>1     0 30853     2  20   0     0    0 conges D    ?        21133795:39 [pdflush]
>1     0 30854     2  20   0     0    0 conges D    ?          0:00 [pdflush]
>
> And yes, rc5 is stone-age, I know.

Bug's been closed, I think it's fixed now.

Grant.
>
>Cheers
>
>Martin 
>------------------------------------------------------
>Martin Knoblauch
>email: k n o b i AT knobisoft DOT de
>www:   http://www.knobisoft.de

