Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbXHVNXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbXHVNXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 09:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXHVNXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 09:23:24 -0400
Received: from namei.org ([69.55.235.186]:34026 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751372AbXHVNXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 09:23:23 -0400
Date: Wed, 22 Aug 2007 06:23:06 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
In-Reply-To: <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
Message-ID: <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au>
References: <20070822083844.%N@1wt.eu> <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Michal Piotrowski wrote:

> I got a problem with SELinux
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/console.log
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/stable-config

Please set
CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT=n

You don't have complete policy for the new network controls, which are not 
enabled by default and not integreated fully into distros yet.


-- 
James Morris
<jmorris@namei.org>
