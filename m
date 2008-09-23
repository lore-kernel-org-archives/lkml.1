Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYIWV1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYIWV1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYIWV0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:26:53 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:49003 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYIWV0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:26:52 -0400
Message-ID: <48D95ECC.9010107@knaff.lu>
Date: Tue, 23 Sep 2008 23:25:32 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu> <48D7C304.4020709@zytor.com> <48D7C48F.8010907@knaff.lu> <48D93E68.6040701@zytor.com> <48D9471E.9090108@knaff.lu> <48D95A8F.10705@zytor.com>
In-Reply-To: <48D95A8F.10705@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> More failures...
> 
> /bin/sh: scripts/bin_size: No such file or directory

Could be a permission issue. Did you try to chmod 755 scripts/bin_size ?
Hmmm, diff does indeed not encode permissions, how should such cases be
usually handled?

> Happens with O=.

What do you mean by this?

>     -hpa

Alain
