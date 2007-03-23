Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbXCWBut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbXCWBut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbXCWBut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:50:49 -0400
Received: from gw.goop.org ([64.81.55.164]:46492 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbXCWBus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:50:48 -0400
Message-ID: <46033204.8030601@goop.org>
Date: Thu, 22 Mar 2007 18:48:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: how can I touch softlockup watchdog on all cpus?
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net> <20070321164404.GF13218@redhat.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB710B@ABGEX01E.abg.fsc.net> <75b66ecd0703220830wdb4a612u86c80e71d4918cc4@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB060@ABGEX01E.abg.fsc.net> <75b66ecd0703220917w2fa7c6afs4817b689f8a2e98f@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB0F5@ABGEX01E.abg.fsc.net> <4603075E.4090001@goop.org> <20070323011617.GB1367@redhat.com>
In-Reply-To: <20070323011617.GB1367@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> He wants to do this with interrupts off. on_each_cpu won't work in
> that situation.
>   

I was thinking just before his big pause.  But it sounds like its fairly
marginal.

>  > Or patch the softlockup watchdog to add a way to temporarily disable it.
>
> Seems pretty much the only way you could make this work.
>   

Yep.  The patches I just posted might do the trick.

    J
