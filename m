Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZJKJGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZJKJGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbZJKJGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:06:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56645 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbZJKJGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:06:33 -0400
Date: Sun, 11 Oct 2009 11:05:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       soni.trilok@gmail.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Haptic class support (v2)
Message-ID: <20091011090549.GE1414@ucw.cz>
References: <20091006074533.GA28889@july>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006074533.GA28889@july>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-10-06 16:45:33, Kyungmin Park wrote:
> This patch includes two haptic devices, isa1000 and isa1200
> ISA1000 is gpio based haptic, but isa1200 is based on I2C
> Both are working on Samsung SoCs and tested.
> 
> To enable the haptic, echo 1 > /sys/class/haptic/${name}/enable
> You can adjust the level by echo ${level} > /sys/class/haptic/${name}/enable
> or
> With oneshot feature, echo ${msec time} > /sys/class/haptic/${name}/oneshot

New device classes should certainly be documented in Documentation/.

For example... is level 0-100? Is it valid to change level while
'oneshot' is running? Does oneshot use last level set?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
