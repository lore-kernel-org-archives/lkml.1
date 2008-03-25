Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYCYMMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYCYMMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYCYMMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:12:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52510 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYCYMME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:12:04 -0400
Message-Id: <1206447122.8428.1244147147@webmail.messagingengine.com>
X-Sasl-Enc: UDQrMo5YeRnTens9rNaKhu6QRoKz2ftBw2OSnMFZ+PTY 1206447122
From: "Kai" <epimetreus@fastmail.fm>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1206240595.9045.1243810639@webmail.messagingengine.com>
   <2c0942db0803222147y27954bd6hf4cb0cc98ceda2da@mail.gmail.com>
Subject: Re: Serious performance regression in Wine applications and Linux
   2.6.24.*
In-Reply-To: <2c0942db0803222147y27954bd6hf4cb0cc98ceda2da@mail.gmail.com>
Date: Tue, 25 Mar 2008 05:12:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 22 Mar 2008 21:47:52 -0700, "Ray Lee" <ray-lk@madrabbit.org>
said:
> On Sat, Mar 22, 2008 at 7:49 PM, Kai <epimetreus@fastmail.fm> wrote:
> > Performance degrades by about 60% when I run Wine under any of the
> >  2.6.24.* kernels. Attached are the output of lspci -vv and the two
> >  config files of each kernel.
> >
> >  I upgraded to 2.6.24, back to 2.6.23.(not sure), then tried 2.6.24.1 and
> >  2.6.24.3 and the issue is present in both; it's severe enough that Wine
> >  apps are virtually unusable for me with this version of the kernel; I'm
> >  having to use 2.6.23 until this somehow is resolved.
> >
> >  I'd like some help figuring out why this performance regression exists,
> >  and what can be done to mitigate it.
> 
> As wine has a 'wineserver' running in a separate process, it may be
> related to scheduler changes.
> 
> Regardless, if you have the time, please retest using he latest git
> head (or nightly snapshot), and see if the performance regression is
> still there, and report back. (There have been a lot of changes
> between 2.6.24 and current git head that impact the scheduler.)
> 
> Please ensure that the fair group scheduler is disabled in your tests
> (just as you have in your 2.6.24 config you attached).

As mentioned in another response, it was happening as recently as
2.6.25-rc6-git7; I'm currently performing a git bisect between 2.6.23
and 2.6.24, unless someone has a better idea; it seems my best option,
as I'm not really very experienced with kernel hacking or debugging.
