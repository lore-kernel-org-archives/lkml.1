Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYGJJfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYGJJfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYGJJe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:34:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:23043 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYGJJe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iJUM9APzIefVS+Oc+QtrpW3fvgkyJy27ssYYbOYuIUILFt3XmltDaYOVMlvsDVfREv
         KmyIWl0z+M9Tc6iQLLsB389r0YD7vHlk6QKgJe2ZhLDb70Yu3WW25P8hJIlI8tlLYADL
         hEgqV3zm4YqxXufa5gWY97pjZG6V0WRoScsC4=
Message-ID: <19f34abd0807100234n46e2229ej5077d8c91d08e9f6@mail.gmail.com>
Date: Thu, 10 Jul 2008 11:34:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Subject: Re: bug in 2.6.26-rc9: sleeping function called from invalid context at kernel/rwsem:21
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4875C615.90102@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4875C615.90102@cateee.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 10:19 AM, Giacomo A. Catenazzi <cate@cateee.net> wrote:
> Hello,
>
> yesterday at shutdown I had a crash. Unfortunately it seems
> that there was one (or more) oops missing. The bug appeared
> at unmounting partition at shutdown, so there are no logs
> of the previous messages.

Thanks for the report.

It would be really useful to know which filesystems you are/were
using, including virtual filesystems like sysfs. Maybe you are using
ecryptfs or FUSE?

(It would also be interesting to see if you could run
/etc/rc0.d/S40umountfs while the machine is up, to see if you can get
the segfault but keep the machine usable enough to get the whole log.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
