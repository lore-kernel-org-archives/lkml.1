Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbZIQT0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbZIQT0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZIQT0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:26:04 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:33682 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZIQT0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:26:04 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 15:26:04 EDT
MIME-Version: 1.0
In-Reply-To: <20090917185306.GA28635@elte.hu>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> 
	<m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 17 Sep 2009 21:18:05 +0200
Message-ID: <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was: 
	Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster)
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 20:53, Ingo Molnar <mingo@elte.hu> wrote:
> I've reproduced a bug with the following .config options:
>
>  CONFIG_DEVTMPFS=y
>  CONFIG_DEVTMPFS_MOUNT=y
>
> /dev/null and /dev/zero are not read/writable to ordinary users,
> breaking normal bootup and login:

Udev should run long before some ordinary/non-root user can login, and
apply the permissions as it always does. It's known to work on Fedora,
SUSE, Ubuntu. What kind of system/environment/setup is that where you
see this?

Kay
