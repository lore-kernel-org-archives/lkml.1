Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZEQShm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZEQShm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 14:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZEQShc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 14:37:32 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:36298 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZEQShb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 14:37:31 -0400
Date: Sun, 17 May 2009 20:37:29 +0200
Message-Id: <720338507@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where do we stand with the Xen patches?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19XbUZKCn6COO8mO2QSxCHBwtwwhv7ObzNGwpHyQQX+iL7db
 R2IGna+kyoXLxdCYsMnygfwDKeFFX0Z1SOuJEJGy4QcqXjcRxk=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Aside from some whitespace issues around some Impact: lines, I 
>> don't know of any outstanding problems.  (I just pushed an updates 
>> to these branches to fix those, and fold a change to address 
>> Jesse's comment.)
>>
>> Please tell me if you have any further issues which prevents you 
>> from pulling these changes.  Otherwise I'd appreciate it if you 
>> pulled them soon, as we're already on -rc5, and I have more 
>> changes I'd like to prep for the next merge window.
>
>As in the past, my main worry is performance overhead of paravirt in 
>general.
>
>The patches that dont affect any native kernel fast path are 
>probably OK (but still pending final review).
>
>Regarding patches that do change the fastpath i'll do a round of 
>measurements of CONFIG_PARAVIRT against !CONFIG_PARAVIRT kernels, 
>and make up my mind based on that.
>
>You could accelerate this by sending some "perf stat" hard numbers 
>to give us an idea about where we stand today.
>
>	Ingo

maybe this is iust a stupid comment (please forgive, i´m no advanced kernel
hacker), but can´t the code inserted by the patches and which changes the 
fastpath just #IFDEF`ed at the critical offsets ?  (as building a dom0 kernel is 
just another build target, isn`t it ?)

regards
roland
______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

