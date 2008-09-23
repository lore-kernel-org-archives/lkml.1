Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYIWVco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYIWVco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYIWVce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:32:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56009 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYIWVcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:32:33 -0400
Message-ID: <48D96013.1070507@zytor.com>
Date: Tue, 23 Sep 2008 14:30:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu> <48D7C304.4020709@zytor.com> <48D7C48F.8010907@knaff.lu> <48D93E68.6040701@zytor.com> <48D9471E.9090108@knaff.lu> <48D95A8F.10705@zytor.com> <48D95ECC.9010107@knaff.lu>
In-Reply-To: <48D95ECC.9010107@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> H. Peter Anvin wrote:
>> More failures...
>>
>> /bin/sh: scripts/bin_size: No such file or directory
> 
> Could be a permission issue. Did you try to chmod 755 scripts/bin_size ?
> Hmmm, diff does indeed not encode permissions, how should such cases be
> usually handled?
> 

git handles them, so that's usually okay.

>> Happens with O=.
> 
> What do you mean by this?

I mean I'm using O= to build in a different object directory.  It 
sometimes means one needs $(src) in places.

	-hpa
