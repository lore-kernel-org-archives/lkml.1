Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXCSPJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXCSPJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbXCSPJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:09:40 -0400
Received: from relay4.usu.ru ([194.226.235.39]:45563 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbXCSPJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:09:39 -0400
Message-ID: <45FEA7C9.1090305@ums.usu.ru>
Date: Mon, 19 Mar 2007 20:10:01 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>	<45FE13B9.8000203@ums.usu.ru> <87vegxdc8i.fsf@duaron.myhome.or.jp>	<45FE2483.4060706@ums.usu.ru> <878xdtux71.fsf@duaron.myhome.or.jp>
In-Reply-To: <878xdtux71.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:

> I'm talking about two filesystems on a system here, not two encoding
> on one filesystem. You can change locale on each filesystems, or each
> directory, of course if it's not vfat.

Note that you can still achieve this insane result by specifying iocharset 
manually for each mount. Only the defaults are changed, but many distros set 
the default iocharset to either iso8859-1 or utf8, both of which are wrong 
for you. So you won't notice any regressions after my patch :)

-- 
Alexander E. Patrakov
