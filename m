Return-Path: <linux-kernel-owner+w=401wt.eu-S1762657AbYBBAB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762657AbYBBAB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761909AbYBBABU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:01:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45784 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761722AbYBBABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:01:19 -0500
Date: Sat, 2 Feb 2008 01:01:17 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
In-Reply-To: <20080201224038.GC17828@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802020100120.18790@fbirervta.pbzchgretzou.qr>
References: <20080201104718.GA11717@uranus.ravnborg.org>
 <20080201030329.9b760777.akpm@linux-foundation.org> <1201864894.23523.117.camel@brick>
 <Pine.LNX.4.64.0802012245250.18790@fbirervta.pbzchgretzou.qr>
 <20080201224038.GC17828@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 1 2008 23:40, Sam Ravnborg wrote:
>> 
>> checkpatch does not parse C, it uses heuristical regexes.
>> 
>> That makes it very different from sparse or the section mismatch
>> finder which do not output false positives.
>
>Unfortunately I most correct you. Section mismatch checks seldoms finds
>what I would call 'real' bugs that causes oops - but it happen.
>It is mostly fasle positives that needs workaround, but also a great
>deal of missing annotation resulting in additional memory saved.
>And then occasionally a bad reference in some error handling that
>seldom trigger but when it does it would oops.

What I meant with false positives:=
modpost warning about something that is not true.

I have not yet seen such happening where code is obviously correct
by the eyeball, but modpost gets it wrong.
