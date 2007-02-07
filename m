Return-Path: <linux-kernel-owner+w=401wt.eu-S965563AbXBGM7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965563AbXBGM7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030299AbXBGM7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:59:51 -0500
Received: from postoffice10.mail.cornell.edu ([132.236.56.14]:33282 "EHLO
	postoffice10.mail.cornell.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965563AbXBGM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:59:50 -0500
Message-ID: <32895.74.71.32.29.1170853186.squirrel@webmail.cornell.edu>
In-Reply-To: <20070207094105.7ab1c601@localhost>
References: <34171.74.71.32.29.1170727713.squirrel@webmail.cornell.edu>
    <20070207094105.7ab1c601@localhost>
Date: Wed, 7 Feb 2007 07:59:46 -0500 (EST)
Subject: Re: PROBLEM: sata timeouts with intel 82801HB on amd64
From: "Trevor Offner Caira" <toc3@cornell.edu>
To: "Paolo Ornati" <ornati@fastwebnet.it>
Cc: "Trevor Offner Caira" <toc3@cornell.edu>, linux-kernel@vger.kernel.org,
       "Tejun Heo" <htejun@gmail.com>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you using XFS, right?
For /usr, /var and /home, yes. For /, no, my root partition is ext3.

> Can you see if the problem goes away either:
>
> 1) disabling NCQ ("echo 1 > /sys/block/sda/device/queue_depth" in a
> boot script)

No, this does not fix it.

> 	OR
>
> 2) mounting XFS filesystem(s) with "nobarrier" option

Neither does this.

Thanks,

Trevor Caira

