Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbXA3LAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbXA3LAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 06:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXA3LAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 06:00:22 -0500
Received: from highlandsun.propagation.net ([66.221.212.168]:4314 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662AbXA3LAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 06:00:22 -0500
Message-ID: <45BF17E6.4070305@symas.com>
Date: Tue, 30 Jan 2007 02:03:18 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9a2pre) Gecko/20070128 Netscape/7.2 (ax) Firefox/1.5 SeaMonkey/1.5a
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Concurrent Page Cache
References: <7IJTB-4sg-17@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This ladder locking is also known as lock-coupling in the database world. 
It's a good solution when you have lots of tasks and need high concurrency, 
and proven in a lot of literature. You might notice more overhead if you only 
have a small number of tasks (e.g. 2-3) but it definitely scales better than 
just holding onto one lock or a small number of locks.
-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc
   OpenLDAP Core Team            http://www.openldap.org/project/
