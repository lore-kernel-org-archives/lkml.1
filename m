Return-Path: <linux-kernel-owner+w=401wt.eu-S967042AbXEHLGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967042AbXEHLGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966486AbXEHLGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:06:52 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966485AbXEHLGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:06:51 -0400
Message-ID: <464059BE.6010304@zytor.com>
Date: Tue, 08 May 2007 04:06:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Florian Fainelli <florian.fainelli@int-evry.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time locale in gen_initramfs_list.sh
References: <200705080755.31157.florian.fainelli@int-evry.fr>
In-Reply-To: <200705080755.31157.florian.fainelli@int-evry.fr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Fainelli wrote:
> I noticed that some zsh users who forced their ls formatting to something non 
> standard could not generate the initramfs file list. Forcing the locale to C 
> while generating seems not to be enough. Adding --time-style=locale will use 
> C locale ls output and will let them generate the initramfs list. It has no 
> side effects for other users.

... except for those whose "ls" doesn't have "--time-style=locale"; how
long has that been implemented?

	-hpa
