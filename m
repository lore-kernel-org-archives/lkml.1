Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYANTxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYANTxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYANTxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:53:09 -0500
Received: from gw.goop.org ([64.81.55.164]:33341 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYANTxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:53:08 -0500
Message-ID: <478BBD79.1080007@goop.org>
Date: Mon, 14 Jan 2008 11:52:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478B9183.3020101@goop.org> <20080114165635.GK15542@elte.hu>
In-Reply-To: <20080114165635.GK15542@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> would be nice to have some debugging apparatus for bugs like this. 
> Perhaps artificially add a large pfn, then convert/unconvert, then 
> subtract it and expect the whole transformation to be an identity 
> mapping? This way we could simulate most of the effects of >4GB RAM, 
> right?

Yeah, good idea.  I'll code something up to run at pagetable init time 
or something.

    J

