Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbYH2ROj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbYH2ROj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYH2RO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:14:28 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:23878 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbYH2RO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:14:27 -0400
Message-ID: <48B82E6E.2090603@hp.com>
Date: Fri, 29 Aug 2008 10:14:22 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Brice Goglin <Brice.Goglin@inria.fr>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [RFC] export irq_set/get_affinity() for multiqueue network drivers
References: <48B708E1.4070001@inria.fr> <20080829055023.07966b4a@infradead.org> <8763pjpy2b.fsf@basil.nowhere.org>
In-Reply-To: <8763pjpy2b.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also I suspect handling SMT explicitely is a good idea. e.g. I would
> always set the affinity to all thread siblings in a core, not 
> just a single one, because context switch is very cheap between them.

That is true, but don't they also "compete" for pipeline resources?

rick jones
