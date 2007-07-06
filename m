Return-Path: <linux-kernel-owner+w=401wt.eu-S1763897AbXGFTx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763897AbXGFTx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761883AbXGFTxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:53:50 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:52873 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760155AbXGFTxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:53:49 -0400
Date: Fri, 6 Jul 2007 21:53:43 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Ryan Hope <rmh3093@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH v2 0/5] uvesafb: a general description
Message-ID: <20070706195343.GA12096@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070630163101.GA3838@spock.one.pl> <48f7fe350707051038p422ea305w10d727bcc44e5d7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <48f7fe350707051038p422ea305w10d727bcc44e5d7b@mail.gmail.com>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 01:38:46PM -0400, Ryan Hope wrote:
>  I applied
>  http://dev.gentoo.org/~spock/projects/uvesafb/archive/uvesafb-0.1-rc2-2.6.22-rc6.patchto
>  2.6.22-rc6-mm1... everything seems to be working properly. However, in dmesg
>  I did notice the following message:
> 
>  uvesafb: message too long (9872), can't execute task
>  uvesafb: VBE get state call failed (eax=0x4f04, err=-7)
> 
>  The messages seem to get generated when I switch VTs. Just thought I would
>  let you know. If there is anything else I can do to help let me know.

It looks like the VBE hardware state buffer for your video card is
larger than the 4k currently supported by connector.  The problem should
be easily fixed by setting CONNECTOR_MAX_MSG_SIZE in include/linux/connector.h
to e.g. 16k.  I've already updated the patch on my website, so next time
you download it, the error messages should be gone.

Best regards,
Michal

