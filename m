Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXCVWqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXCVWqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXCVWqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:46:52 -0400
Received: from gw.goop.org ([64.81.55.164]:35585 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbXCVWqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:46:51 -0400
Message-ID: <4603075E.4090001@goop.org>
Date: Thu, 22 Mar 2007 15:46:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
CC: Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: how can I touch softlockup watchdog on all cpus?
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net> <20070321164404.GF13218@redhat.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB710B@ABGEX01E.abg.fsc.net> <75b66ecd0703220830wdb4a612u86c80e71d4918cc4@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB060@ABGEX01E.abg.fsc.net> <75b66ecd0703220917w2fa7c6afs4817b689f8a2e98f@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB0F5@ABGEX01E.abg.fsc.net>
In-Reply-To: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB0F5@ABGEX01E.abg.fsc.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cestonaro, Thilo (external) wrote:
> It's a condition of a customer of us, so I can't change it.
>
> But it happens not often that my part is used. So I thought there is a mechanism to disable or reset the watchdog
> because it is a legal pause for it. And there is one "touch_softlockup_watchdog()", that does what I want,
> BUT just for the current cpu. And so the watchdog blats from the other cpu.
>   

on_each_cpu(touch_softlockup_watchdog, NULL, 0, 0)?

Or patch the softlockup watchdog to add a way to temporarily disable it.

    J
