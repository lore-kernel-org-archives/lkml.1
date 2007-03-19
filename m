Return-Path: <linux-kernel-owner+w=401wt.eu-S966043AbXCSRgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966043AbXCSRgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966047AbXCSRgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:36:37 -0400
Received: from mail.parknet.jp ([210.171.160.80]:2227 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966043AbXCSRgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:36:36 -0400
X-AuthUser: hirofumi@parknet.jp
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>
	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>
	<45FE13B9.8000203@ums.usu.ru> <87vegxdc8i.fsf@duaron.myhome.or.jp>
	<45FE2483.4060706@ums.usu.ru> <878xdtux71.fsf@duaron.myhome.or.jp>
	<45FEA7C9.1090305@ums.usu.ru>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 20 Mar 2007 02:36:30 +0900
In-Reply-To: <45FEA7C9.1090305@ums.usu.ru> (Alexander E. Patrakov's message of "Mon\, 19 Mar 2007 20\:10\:01 +0500")
Message-ID: <87wt1dnnj5.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:

> Note that you can still achieve this insane result by specifying iocharset 
> manually for each mount. Only the defaults are changed, but many distros set 
> the default iocharset to either iso8859-1 or utf8, both of which are wrong 
> for you. So you won't notice any regressions after my patch :)

Nope. In fedora, it uses NLS_DEFAULT="utf8" and FAT_DEFAULT_IOCHARSET="ascii".
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
