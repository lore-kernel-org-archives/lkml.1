Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYJNFRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYJNFRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 01:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYJNFRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 01:17:35 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60359 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYJNFRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 01:17:35 -0400
Message-ID: <48F42A93.1040004@cs.helsinki.fi>
Date: Tue, 14 Oct 2008 08:13:55 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Tom Zanussi <zanussi@comcast.net>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
References: <20080923212914.GB5237@localhost>	 <1223386477.28348.42.camel@penberg-laptop>	 <1223623191.8959.26.camel@penberg-laptop>	 <1223628687.8959.37.camel@penberg-laptop>	 <1223629803.8959.40.camel@penberg-laptop>	 <1223631723.8959.46.camel@penberg-laptop>	 <1223701131.7489.25.camel@charm-linux>	 <1223881068.31587.1.camel@penberg-laptop> <1223957031.10883.7.camel@charm-linux>
In-Reply-To: <1223957031.10883.7.camel@charm-linux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

Tom Zanussi wrote:
> To me, that sounds like how it should work - if kmemtrace is disabled,
> it shouldn't be logging anything, and that's in fact what I saw when
> debugging this - it started out disabled and therefore nothing being
> logged to relay (printks confirmed that).  When I wrote 1 to the enabled
> file, data started getting logged to relay and to the *.out files.
> 
> So I don't know why the enabled state behaves the way it does, or if
> it's unexpected, but that anyway doesn't seem like a relay problem to
> me.

Oh, right. Looking at kmemtraced.c, we never enable kmemtrace, just 
disable it (which doesn't make much sense). Bug in README or the code. 
Eduard?

Btw, Tom, you can add my

Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>

to your patch if you want. Are you going to send it to Andrew or do you 
want me to pick it up with rest of the kmemtrace patches?

		Pekka
