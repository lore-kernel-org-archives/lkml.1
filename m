Return-Path: <linux-kernel-owner+w=401wt.eu-S1764685AbYDPN7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764685AbYDPN7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYDPN7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:59:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40185 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYDPN7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:59:08 -0400
Message-ID: <48060625.4040509@firstfloor.org>
Date: Wed, 16 Apr 2008 15:59:01 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <vda.linux@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Does process need to have a kernel-side stack all the time?
References: <200804141547.57719.vda.linux@googlemail.com>	<87hce4uya8.fsf@basil.nowhere.org>	<20080416124728.GA5050@elte.hu> <20080416065451.78329e12@laptopd505.fenrus.org>
In-Reply-To: <20080416065451.78329e12@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> well that and the fact that RH had customers who had major issues at fewer threads
> with 8Kb versus fragmentation.
> on 32 bit with a bunch of ram, there's just not enough lowmem around to not have it
> fragmented to hell and back.

2.6 VM has much more aggressive defrag heuristics than 2.4. That is what
I meant with likely obsolete.

-Andi
