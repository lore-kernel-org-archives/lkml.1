Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYKDRfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYKDRfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYKDRfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:35:34 -0500
Received: from lazybastard.de ([212.112.238.170]:56774 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbYKDRfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:35:33 -0500
Date: Tue, 4 Nov 2008 18:35:24 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: Linux Arm Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: arm checkstack
Message-ID: <20081104173524.GB16036@logfs.org>
References: <49107304.2060006@parrot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49107304.2060006@parrot.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 November 2008 17:06:28 +0100, Matthieu CASTET wrote:
> 
> I wonder why the arm version of checkstack only catch stack size >= 300
> and < 10000 [1].
> Why doesn't it use ".*sub.*sp, sp, #([0-9]{1,8})" to catch all stack usage ?

Looks like a bug.  And it further looks like Holger just copied what
everyone else did at the time.  And the one who started this strange
pattern was: Arnd.

Arnd, did you have a good reason for choosing the pattern?

> [1]
> $re = qr/.*sub.*sp, sp, #(([0-9]{2}|[3-9])[0-9]{2})/o;

Jörn

-- 
The cost of changing business rules is much more expensive for software
than for a secretaty.
-- unknown
