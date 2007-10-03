Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbXJCCPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbXJCCPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXJCCPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:15:35 -0400
Received: from smtp105.sbc.mail.re2.yahoo.com ([68.142.229.100]:37946 "HELO
	smtp105.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754820AbXJCCPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:15:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=MkoWKBR4nAVT7auXATO5YdTji4CspC8L8aoC4uFgbG3R0F1AsJ1It1VbG+0Al4fAddIXPOAqGm5wvSLujnKCXXv5/ye2J6l3B5QlPWK7MkHf7av5KXh/pZUGdjPtJE5pIq9AM1LZmk5w/jM5IpvN0nD0PwMgWT97bfb4z/jX5os=  ;
X-YMail-OSG: iydYxmMVM1ns6Phj7b93sMGO_Wx5zCN3GkUudBpBTMaT_osajYFBitoYhH3NiLMC8J_Nqky6AQ--
Date: Tue, 02 Oct 2007 19:15:36 -0700
From: David Brownell <david-b@pacbell.net>
To: pavel@ucw.cz
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       alessandro.zummo@towertech.it
References: <20070920103225.GA4410@elf.ucw.cz>
 <20070920105002.GA4611@elf.ucw.cz>
 <200709212238.05130.david-b@pacbell.net>
 <20071002093641.GA11039@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20071002093641.GA11039@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071003021537.208621F9CA8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> > > > root@amd:/sys/class/rtc/rtc0# echo 132719 > wakealarm 
> > 
> > At which point I'd expect
> > 
> > # echo $?
> > 
> > would indicate the write failed.  That's a LONG time in the
> > past (January 2, 1970), so that setting would be rejected.
>
> echo $? says 0 here :-(.

I stand corrected.  What it should do -- and does -- in that case
involves disabling the alarm, then succeeding.

