Return-Path: <linux-kernel-owner+w=401wt.eu-S1946818AbXBJBBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946818AbXBJBBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946815AbXBJBBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:01:55 -0500
Received: from independence.hostmaven.com ([64.92.166.42]:34550 "EHLO
	andromeda.hostmaven.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946818AbXBJBBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:01:54 -0500
X-Greylist: delayed 3671 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 20:01:54 EST
Message-ID: <63744.68.227.81.52.1171065650.squirrel@connectyourweb.com>
Date: Fri, 9 Feb 2007 16:00:50 -0800 (PST)
Subject: PROBLEM: xt_state compiles without errors but cannot be loaded
From: "Administrative Services" <admin@connectyourweb.com>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - andromeda.hostmaven.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [32091 32091] / [47 12]
X-AntiAbuse: Sender Address Domain - connectyourweb.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] module: xt_state compiles without errors but cannot be loaded

[2.] Here's what shows up in /var/log/messages:

kernel: xt_state: Unknown symbol nf_conntrack_untracked

kernel: xt_state: Unknown symbol nf_ct_l3proto_module_put

kernel: xt_state: disagrees about version of symbol xt_unregister_matches

kernel: xt_state: Unknown symbol xt_unregister_matches

kernel: xt_state: Unknown symbol nf_ct_l3proto_try_module_get

kernel: xt_state: disagrees about version of symbol xt_register_matches

kernel: xt_state: Unknown symbol xt_register_matches


[3.] modules, netfilter:

[4.] 2.6.20:

[5.] 2.6.19.2 possibly 2.6.9.3:

[7.] try loading module using insmod

[8.] CentOS 4.4
[8.1.] apf 0.9.6 (modified to use xt_state), and insmod

