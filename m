Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbXC0POo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbXC0POo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXC0POo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:14:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbXC0POn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:14:43 -0400
Message-ID: <460934D7.9030700@redhat.com>
Date: Tue, 27 Mar 2007 11:14:31 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Pete Zaitcev <zaitcev@redhat.com>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       Peter Osterlund <petero2@telia.com>
Subject: Re: Fix sudden warps in mousedev
References: <20070324001610.724a820a.zaitcev@redhat.com> <d120d5000703261230h1724e453je2c14769fc099ad3@mail.gmail.com> <20070326144206.93805eeb.zaitcev@redhat.com> <200703262114.45287.dtor@insightbb.com>
In-Reply-To: <200703262114.45287.dtor@insightbb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> 
> The driver grabs tochpad with EVIOCGRAB ioctl to prevent input events
> from bveing delivered to X through /dev/input/mice which is still in
> whidespread use. That's why evtest does not work. We could as Peter
> (CCed) to implement an option to turn off grabbing so users who don't
> use mousedev multiplexor can use evtest and other commands.
> 

What should people be using instead of /dev/input/mice ?

And why did the mouse numbers all get rearranged in 2.6.20, e.g.
mouse1 became mouse2 for many people?

