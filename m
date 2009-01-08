Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbZAHWlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbZAHWlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZAHWlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:41:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbZAHWlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:41:22 -0500
Message-ID: <20090108224120.JAKWM.227684.root@hrndva-web20-z02>
Date: Thu, 8 Jan 2009 17:41:19 -0500
From: <lmage11@twcny.rr.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Curious problems with /proc/kmsg?
In-Reply-To: <20090101223925.PJUBH.263802.root@hrndva-web18-z01>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Sensitivity: Normal
X-Originating-IP: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---- lmage11@twcny.rr.com wrote: 
> I'm currently trying to debug a problem with my wireless driver,
> and while looking at the copious output that the driver produces,
> I've been noticing some very odd stuff come out of /proc/kmsg (which
> is also where my syslog daemon gets kernel messages). I'm getting stuff
> like:
> 
> Jan  1 01:59:02 tank ieee80211 phy0: I iwl4965_mac_tx enter
> Jan  1 01:59:02 tank ieee80211 phy0: I iwl4965_mac_tx leave
> Jan  1 01:59:02 tank ieee80211 phy0: I iwl4965_mac_tx enter
> Jan  1 01:59:02 tank ieee80211 phy0: I iwl4965_mac_tx leave
> Jan  1 01:59:03 tank ieee80211 phy0: I iwl4965_mac_tx ente
> Jan  1 01:59:03 tank 3ie821py:Iil95mct ev
> Jan  1 01:59:03 tank 3ie821py:Iil95mct ne
> Jan  1 01:59:03 tank 3ie821py:Iil95mct ev
> Jan  1 01:59:03 tank 3ie821py:Iil95mct ne
> Jan  1 01:59:03 tank 3ie821py:Iil95mct ev
> Jan  1 01:59:03 tank 3ie821py:Iil95mct ne
> Jan  1 01:59:03 tank 3ie821py:Iil95mct ev
> 
> As you can see, the first few lines are fine, but the next few
> lines are complete nonsense. It looks to me as if characters
> are getting semi-randomly "skipped" sometimes, or something???
> Very strange. This oddity does not show up when I look at the
> kernel output through dmesg.
> 
> Some more examples of strange output follow:
> 
> Jan  1 01:59:04 tank w46_a_xlae<>ee01 h0  w46_a_xetr<>ee01 h0  w46_a_xlae<3>ieee80211 phy0: I iwl4965_mac_tx enter
> Jan  1 01:59:04 tank ieee80211 phy0:  iwleqeehm edn omn ESTVT_M #8,sq x46 8btsa 6[]4<>ee01 h0  w_eei_m_alakbc rmSNIIIYCD(x0000
> Jan  1 01:59:05 tank 3ie821py:Iilgnrccdclbc akfo EL_XLN_ULT_M 00000)<>ee01 h0  w46_a_xetr<>ee01 h0  w46_a_xlaev
> 
> Any comments? I'm using 2.6.28.
> 
> Thanks!
> 
> Ari

Umm... Bump?
