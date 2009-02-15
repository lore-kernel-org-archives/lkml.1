Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZBOQKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZBOQKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 11:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZBOQKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 11:10:10 -0500
Received: from main.gmane.org ([80.91.229.2]:43681 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZBOQKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 11:10:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Poking ieee80211_default_rc_algo causes kernel lockups
Date: Sun, 15 Feb 2009 16:09:57 +0000 (UTC)
Message-ID: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 79-68-117-143.dynamic.dsl.as9105.com
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As mentioned on
http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/d4a6ce26360613fa/b362792a2debced6?#b362792a2debced6
, poking /sys/module/mac80211/parameters/ieee80211_default_rc_algo and
then trying to read values back is currently causing the kernel to go
funny. E.g.
echo blah > /sys/module/mac80211/parameters/ieee80211_default_rc_algo
cat /sys/module/mac80211/parameters/ieee80211_default_rc_algo

Causes 2.6.29rc5 on my EeePC 900 to lock up.

-- 
Sitsofe

