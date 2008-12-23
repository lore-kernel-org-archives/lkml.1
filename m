Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbYLWMxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbYLWMxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 07:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYLWMxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 07:53:24 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:1333 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLWMxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 07:53:23 -0500
X-Greylist: delayed 1656 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Dec 2008 07:53:23 EST
Message-ID: <4950D8B5.5040404@phoenixsoftware.de>
Date: Tue, 23 Dec 2008 13:25:25 +0100
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>
Subject: dynamic_printk documentation
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.151 () AWL,BAYES_50,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where is the current debugfs interface to dynamic_printk documented?
>From the source in lib/dynamic_printk.c I deduced that

echo "set enable=1 <module_name>" > /sys/kernel/debug/dynamic_printk/modules

should enable debug output for module <module_name>, and verified
experimentally that this does indeed work. Is that already described
somewhere I just overlooked? If not, I would propose creating a file
Documentation/dynamic_printk.txt.

Thanks,
Tilman
