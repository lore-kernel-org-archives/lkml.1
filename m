Return-Path: <linux-kernel-owner+w=401wt.eu-S933676AbXGWAqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbXGWAqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933699AbXGWApy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:45:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:46305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933689AbXGWApx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=n7dLS3nUSIcBPpsn6x6kUYwRcGdfJ5UV3hk+cOlDY7MDwU6vdNclcTdxpMJRSVNo8X1jaKrhhFxbtGqDm5baXv2IAOiiOQBCzEMAUSqcp2faEIIruh80sPpnLIlnyPRMcfwmJCpU+DzBQ33dsFN7oAk5HN8NbrAV0khgijwv3dk=
Message-ID: <46A3F9B1.9070207@googlemail.com>
Date: Mon, 23 Jul 2007 02:43:29 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jaroslav Kysela <perex@suse.cz>
Subject: sound/core/init.c - address of 'snd_shutdown_f_ops' will always evaluate
 as 'true' , warning
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this warning on current git using gcc 4.2.1:

...

sound/core/init.c: In function 'snd_card_disconnect':
sound/core/init.c:307: warning: the address of 'snd_shutdown_f_ops' will always evaluate as 'true'

...


Regards,

Gabriel C
