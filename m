Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbXLEKeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbXLEKeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXLEKeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:34:16 -0500
Received: from twin.jikos.cz ([213.151.79.26]:50497 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbXLEKeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:34:15 -0500
Date: Wed, 5 Dec 2007 11:33:20 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Patrick Boettcher <pb@linuxtv.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [build bug] undefined reference to `dib3000mc_get_tuner_i2c_master'
In-Reply-To: <20071204105439.GA20175@elte.hu>
Message-ID: <Pine.LNX.4.64.0712051132340.2935@twin.jikos.cz>
References: <20071204083904.GA15694@elte.hu> <Pine.LNX.4.64.0712041130310.16564@twin.jikos.cz>
 <20071204105439.GA20175@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Ingo Molnar wrote:

> > Hmm, seems like -common part contains also code that is not completely 
> > common to all the modules.
> > How about this?
> that does the trick and 2.6.24-rc4 now builds & boots fine with that 
> config. Thanks,
> Tested-by: Ingo Molnar <mingo@elte.hu>

Mauro, Patrick, are you going to take it through your trees, or should I 
push it through akpm?

-- 
Jiri Kosina
