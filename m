Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZLKOGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZLKOGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZLKOGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:06:34 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:55984 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZLKOGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:06:33 -0500
Date: Fri, 11 Dec 2009 08:06:39 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Ioannis Kyriakopoulos <johnkyr83@hotmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Finding and chaniging registered clocksources
In-Reply-To: <SNT111-DS372EC73016B4FB39E0ACAA78C0@phx.gbl>
Message-ID: <alpine.DEB.2.00.0912110802250.32415@router.home>
References: <SNT111-DS372EC73016B4FB39E0ACAA78C0@phx.gbl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009, Ioannis Kyriakopoulos wrote:

> However, I don't know how to found out what clocksource Linux has assigned
> for other activities apart from the one mentioned (e.g. for timekeeping) and
> how to change it, if possible.

Depends on the subsystem. Code can use time sources as needed but in
general the standard clock is used as a common time base.

> For example, I want to find out which clocksource getnstimeofday() is using.
> It could be also useful if there is a way to see all the registered
> clocksources in the system.

getnstimeofday uses the syste, cllock that can be retrieved using
/sys/devices/system/clocksource/clocksource0/current_clocksource

