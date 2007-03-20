Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbXCTQxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbXCTQxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbXCTQxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:53:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:41254 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbXCTQxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:53:48 -0400
To: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UDP packets scheduling
References: <20070320005228.GN22880@mail.muni.cz>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Mar 2007 18:52:51 +0100
In-Reply-To: <20070320005228.GN22880@mail.muni.cz>
Message-ID: <p73r6rj6bv0.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek <xhejtman@mail.muni.cz> writes:

> Flow control must be turned off for some other reason.

That's your fundamental problem. Fix that. 

Even if you get the rate right there can be many reasons why timing 
gets disrupted temporarily and to recover from any of this you need
working flow control.

-Andi
