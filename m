Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbYCZAB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbYCZAB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYCZABs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:01:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56065 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbYCZABr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:01:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E99258.3060005@s5r6.in-berlin.de>
Date: Wed, 26 Mar 2008 01:01:28 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Marcus Better <marcus@better.se>
CC: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10327] New: keyboard stops responding after
 "ifdown eth0"
References: <bug-10327-10286@http.bugzilla.kernel.org/> <20080325143941.300d415f.akpm@linux-foundation.org> <47E9721C.2000306@better.se>
In-Reply-To: <47E9721C.2000306@better.se>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One possible reason for unresponsive keyboard is a workqueue job in the 
shared workqueue sleeping very long or indefinitely.

Sky2.c has only one workqueue job: sky2_restart().
-- 
Stefan Richter
-=====-==--- --== ==-=-
http://arcgraph.de/sr/
