Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYGRHGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYGRHGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYGRHGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:06:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:34111 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYGRHGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:06:08 -0400
Date: Fri, 18 Jul 2008 00:07:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: linux-kernel <linux-kernel@vger.kernel.org>
cc: jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
       bruce.w.allan@intel.com, john.ronciak@intel.com,
       auke-jan.h.kok@intel.com, davem@davemloft.net
Subject: wierd networking problem on 2.6.26 with e1000
Message-ID: <alpine.DEB.1.10.0807172357390.6370@asgard>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apologies for the poor report, I'll learn more tomorrow.

I've got a pair of boxes dual opteron dual-core with 16G ram LSI raid, and 
several quad E1000 cards. I had an emergancy requiring me to setup the 
boxes quickly for a new purpose, on one of them I left my old 2.6.22.1 32 
bit build, but on the other I tried a 2.6.26 64 bit build. both boxes have 
the same 32 bit userspace and are running heartbeat to move a VIP from one 
to the other.

when I logged into the 2.6.22.1 box and ssh'd over to the 2.6.26 box I had 
no communications problems at all, but if I moved the VIP (eth0:0) onto 
the 2.6.26 box and connected in to that I would occasionally see delays of 
a min or two where I lost all communications with the box. At the time 
this breakdown happened I was still connected in from the 2.6.22 box to 
the real IP of the second one with no problems, but attempts to connect to 
that real IP from other systems failed (unable to get an ARP response)

I will be able to post my configs tomorrow, but the version difference 
between the two kernels will limit the usability of that. any suggestions 
on other things I should do when I setup a new test?

David Lang
