Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXCVLht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXCVLht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 07:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030517AbXCVLht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 07:37:49 -0400
Received: from hosting4p.com ([81.0.235.160]:50730 "EHLO micron1.hosting4p.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030502AbXCVLhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 07:37:48 -0400
Message-ID: <46026A92.4020106@slax.org>
Date: Thu, 22 Mar 2007 12:37:54 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local>
In-Reply-To: <20070322110058.GB23664@tatooine.rebelbase.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 255 loop devices are insufficient? What kind of scenario do you have
> in mind?
> 
> 

Thank you very much for replying.

In 1981, Bill Gates said that 64KB of memory is enough for everybody.
And you know how much RAM do you have right now. :)

Every limit is bad. The limit of 255 loop devices has been introduced 
years ago, in the times when minor device number has been limited by 
255. Nowadays, there is no such limitation.

There are many possible/reasonable uses for more than 255 loop devices. 
For example CD/ISO server. My project, Slax Linux live, is based on 
modular approach where many parts of the root filesystem are stored 
separately in compressed read-only loop files, and are mounted and 
unioned to a single root by using union fs (aufs).

The question is not "Why do we need more than 255 loops?".
The question should be "Why do we need the hardcoded 255-limit in kernel 
while there is no reason for it at all?"

My patch simply removes the hardcoded limitation.


Tomas M
slax.org

