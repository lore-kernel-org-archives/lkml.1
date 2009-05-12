Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZELTpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZELTpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZELTpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:45:32 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:62179 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZELTpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:45:32 -0400
Date: Tue, 12 May 2009 21:45:31 +0200
Message-Id: <711906814@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alok Kataria <akataria@vmware.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Reduce the default HZ value
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19eo5mpcPCPIDxAd2KY5KWYy2UUdc0upD8VoZ4fGK0DgUH9d
 CVUUXX2NMEe96NlHc12ti3U5XnhEZaq87sCnIIlvfeqSzkgTqM=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > As a side note Red Hat ships runtime configurable tick behaviour in RHEL
>> > these days. HZ is fixed but the ticks can be bunched up. That was done as
>> > a quick fix to keep stuff portable but its a lot more sensible than
>> > randomly messing with the HZ value and its not much code either.
>> > 
>> Hi Alan, 
>> 
>> I guess you are talking about the tick_divider patch ? 
>> And that's still same as reducing the HZ value only that it can be done
>> dynamically (boot time), right ? 
>
>Yes - which has the advantage that you can select different behaviours
>rather than distributions having to build with HZ=1000 either for
>compatibility or responsiveness can still allow users to drop to a lower
>HZ value if doing stuff like HPC.
>
>Basically it removes the need to argue about it at build time and lets
>the user decide.

any reason why this did not reach mainline?
is it because there were issues with clocksource=pit ?

regards
roland

______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

