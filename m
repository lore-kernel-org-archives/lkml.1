Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbYJ0XGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbYJ0XGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYJ0XGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:06:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38970 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYJ0XGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:06:07 -0400
Date: Mon, 27 Oct 2008 21:07:28 -0200
From: Glauber Costa <glommer@redhat.com>
To: npiggin@suse.de
Cc: avi@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       mtosatti@redhat.com
Subject: kvm broken with new vmap
Message-ID: <20081027230728.GA30906@poweredge.glommer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nick,

KVM is currently broken upstream, starting with commit
db64fe02258f1507e13fe5212a989922323685ce (rewrite vmap layer)

The symptoms are some vmallocs from kvm fail.
cat /proc/meminfo shows this at the time of the fail:

VmallocTotal:     122880 kB
VmallocUsed:       15184 kB
VmallocChunk:      83764 kB

so there's plenty of space.

The allocation that fails seem to be 512 bytes long. I'm not
sure it always fails in there, but it seems so.


