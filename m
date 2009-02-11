Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbZBKWfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbZBKWfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZBKWev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:34:51 -0500
Received: from gw.goop.org ([64.81.55.164]:37994 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbZBKWeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:34:50 -0500
Message-ID: <49935287.3000504@goop.org>
Date: Wed, 11 Feb 2009 14:34:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: more header untangling
References: <4991D626.5040009@goop.org> <20090211100323.GE20518@elte.hu> <49930485.3070204@goop.org> <20090211171439.GA9185@elte.hu> <49931F04.80605@goop.org> <20090211194719.GA25968@elte.hu>
In-Reply-To: <20090211194719.GA25968@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Another possibility would be to make a further distinction between 'local methods' 
> and 'compound methods'. Local methods are the ones that only relate to a given
> data type. Compound methods combine multiple types. We could allow local methods in 
> type headers, and forbid compound methods.
>   

Yes, that's pretty much the approach I've been taking.  Particularly 
since these little helper functions are smoothing over a given type 
being defined in different ways in different environments (the types 
themselves are different, but the types of the functions operating on 
them are the same).

    J
