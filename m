Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbYBZXcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbYBZXcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYBZXbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:31:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:35042 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYBZXbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JpA+JV6eBK+lz39K6bPlX+GtY9CZtMZIVZIDnhLoFjJKX0af7CxXhrVu9msJRahV9vo0UDXzoZyQowB32MF64rVe2PL9wuxCkPQxcIoFCrEQ4TKL3DJQBKd7DBMK8rQ92fGYx86Tg9cvG7ODigBwiVJrrCpQKJR9o/7DuMBZEws=
Message-ID: <2c0942db0802261531s140aaa82w1daa1829b5a36a4a@mail.gmail.com>
Date: Tue, 26 Feb 2008 15:31:51 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Cc: "Pavel Machek" <pavel@ucw.cz>, "Dave Jones" <davej@codemonkey.org.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080226105606.e56e4ec6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080225143932.6b83b65d.akpm@linux-foundation.org>
	 <20080225225820.GP2659@elf.ucw.cz>
	 <20080225155550.4a020dfb.akpm@linux-foundation.org>
	 <20080226000007.GB22102@atrey.karlin.mff.cuni.cz>
	 <20080226101117.GA26671@atrey.karlin.mff.cuni.cz>
	 <20080226174613.GA26259@codemonkey.org.uk>
	 <20080226175954.GA5707@elf.ucw.cz>
	 <20080226181001.GA7714@codemonkey.org.uk>
	 <20080226181611.GB6030@elf.ucw.cz>
	 <20080226105606.e56e4ec6.akpm@linux-foundation.org>
X-Google-Sender-Auth: 4487abd05fbcfe5a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 10:56 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  First thing we need to do is to work out why it won't stay suspended?

Forgive me the stupid question, but you don't happen to have Wake On
LAN or somesuch enabled in your BIOS, do you? (Given yours stays down
for five seconds then resumes, and other T61 owners aren't seeing that
behavior... <shrug>)

For Pavel and Rafael: Is there some sort of event that gets handed
back on resume to let the kernel know why the system woke up? One
would think that the Wake On LAN (keyboard, timer, etc.) would hand a
notification over to the OS. One is often wrong though.
