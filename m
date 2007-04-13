Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXDMRkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXDMRkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 13:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXDMRkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 13:40:36 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:48532 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbXDMRkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 13:40:36 -0400
Message-ID: <461FC07C.1010600@cosmosbay.com>
Date: Fri, 13 Apr 2007 19:40:12 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Witold Krecicki <wpk@dst-labs.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Oddness with reading /proc/net/tcp
References: <200704131846.16358.wpk@dst-labs.com>
In-Reply-To: <200704131846.16358.wpk@dst-labs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 13 Apr 2007 19:40:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Witold Krecicki a écrit :
> Reading data from /proc/net/tcp is slower with progress of reading data, 
> tested on system with >200k active connections.
> 

Yes, this is a known problem.

This is O(N^2) algo.

Use ss from iproute package to get better performance... (less than 15 seconds 
  for 200k active connections)



