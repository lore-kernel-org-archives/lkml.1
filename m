Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYE1CGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYE1CGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 22:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYE1CG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 22:06:28 -0400
Received: from host26.201-252-16.telecom.net.ar ([201.252.16.26]:48106 "EHLO
	kaoz.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYE1CG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 22:06:28 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 22:06:28 EDT
Message-ID: <483CBCDD.10401@lugmen.org.ar>
Date: Tue, 27 May 2008 23:01:01 -0300
From: Fede <fedux@lugmen.org.ar>
User-Agent: Thunderbird 2.0.0.14 (X11/20080522)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bad pmd ffff810000207238(9090909090909090).
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today I tried to start a firewalling script and failed due to an 
unrelated issue, but when I checked the log I saw this:

May 27 20:38:15 kaoz ip_tables: (C) 2000-2006 Netfilter Core Team
May 27 20:38:28 kaoz Netfilter messages via NETLINK v0.30.
May 27 20:38:28 kaoz nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
May 27 20:38:28 kaoz ctnetlink v0.93: registering with nfnetlink.
May 27 20:38:28 kaoz ClusterIP Version 0.8 loaded successfully
May 27 20:38:28 kaoz mm/memory.c:127: bad pmd 
ffff810000207238(9090909090909090).

I also found another post with a very similar issue. The other post had 
almost the same message (*mm*/*memory*.*c*:*127*: *bad* *pmd* 
ffff810000207808(9090909090909090).)

Does anyone know what is it?
