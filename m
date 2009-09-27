Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZI0Szc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZI0Szc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZI0Szc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:55:32 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:49239 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbZI0Szb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:55:31 -0400
Message-ID: <4ABFB524.5030008@cesarb.net>
Date: Sun, 27 Sep 2009 15:55:32 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] WARN_ONCE(): use bool for condition
References: <4ABFAB27.1040608@cesarb.net>	 <1254075912-17557-1-git-send-email-cesarb@cesarb.net> <1254076108.20648.529.camel@desktop>
In-Reply-To: <1254076108.20648.529.camel@desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker escreveu:
> On Sun, 2009-09-27 at 15:25 -0300, Cesar Eduardo Barros wrote:
>> -               int __ret_warn_on = !!(condition);                      \
>> +               bool __ret_warn_on = (condition);                       \
> 
> Did you try it without removing the "!!" ? In my original email I tested
> the path of least resistance, and I left the "!!" in there..

Just tried, same result (it seems gcc can easily see past the double 
negation).

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
