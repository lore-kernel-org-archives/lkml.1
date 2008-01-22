Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbYAVWcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbYAVWcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYAVWb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:31:57 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4055 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbYAVWb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:31:56 -0500
Date: Tue, 22 Jan 2008 17:15:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8: iwl3945 gets stuck
Message-ID: <20080122221542.GD3206@tuxdriver.com>
References: <479657F3.2030901@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479657F3.2030901@t-online.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 09:54:11PM +0100, Harald Dunkel wrote:

> If I put some heavy load on the iwl3945, then the network connection
> gets stuck after a some time. To fix it I have to reload the module.

Can you quantify this a bit more?  What constitutes a "heavey load"?
What (if any) encryption are you using?  Are you using any options
for iwl3945 in /etc/modprobe.conf?

Could you include the output of dmesg and/or the contents of
/var/log/messages (trimmed for the most recent boot)?

> AFAICS this problem was a topic on lkml almost 3 months ago. Any news
> about this? I would be glad to help to track this down, but I have
> no idea how to change the scaling algorithm to iwl-3945-rs .

This should happen automatically now.

John
-- 
John W. Linville
linville@tuxdriver.com
