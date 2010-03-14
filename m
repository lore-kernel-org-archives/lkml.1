Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0CNHtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 03:49:10 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:61869 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab0CNHtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 03:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=PaI7U/YgQBsEokkt71k0GyRn1/TjTUboSsH3thaOYFJGnmZzrvWM3u6H3QoI5Mh1QS
         e6+ZXKy9hDErWacLYXfZNeCaWV2qv9FguiAkoQ3bK1Gnuj+LxgrP63T29uWH+BD0p+Et
         rtfNl4l5c5YqmGszdh3BsjMmh2JbGFl7P81kc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/5] Assorted patches for firmware loader
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 13 Mar 2010 23:49:02 -0800
Message-ID: <20100314074330.27035.38765.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The latest lockdep warning coming form firmware loader code prompted me
to take a look at it and I thought that it could use a bit of cleaning up,
especially the part where old code was allocating 3 data structures
having the same life time separately whereas they could be combined into
one and allocated in one shot.

Please consider applying. Note that I already sent you first patch a couple
of days ago...

Thanks.

-- 
Dmitry
