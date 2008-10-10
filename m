Return-Path: <linux-kernel-owner+w=401wt.eu-S1762969AbYJJRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762969AbYJJRTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759533AbYJJRTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:19:04 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:40720 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759553AbYJJRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:19:03 -0400
Message-ID: <48EF8E77.8050000@nortel.com>
Date: Fri, 10 Oct 2008 11:18:47 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Greg Kurz <gkurz@fr.ibm.com>
CC: Oren Laadan <orenl@cs.columbia.edu>, Ingo Molnar <mingo@elte.hu>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we	expect checkpoint/restart
 to work
References: <20081009190405.13A253CB@kernel> <1223626834.8787.8.camel@localhost.localdomain> <48EF144D.1050906@fr.ibm.com> <20081010145934.GF11695@elte.hu> <48EF7211.2000303@cs.columbia.edu> <1223656489.10017.33.camel@localhost.localdomain>
In-Reply-To: <1223656489.10017.33.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Oct 2008 17:18:51.0793 (UTC) FILETIME=[4402D010:01C92AFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kurz wrote:

> This flag is weak... testing it gives absolutly no hint whether the
> checkpoint may succeed or not. As it is designed now, a user can only be
> aware that checkpoint is *forever* denied. I agree that it's only useful
> as a "flexible CR todo list".

I don't think it's true that it gives "absolutly no hint".

If the flag is not set, then checkpoint will succeed, right?  Whereas if 
the flag is set, then it's an indication that checkpoint could fail (but 
may still succeed if whatever condition caused the flag to be set is no 
longer true).

Chris

