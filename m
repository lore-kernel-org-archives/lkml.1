Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbXEARON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbXEARON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbXEARON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:14:13 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:38242 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbXEAROL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:14:11 -0400
Message-ID: <46377561.4050703@simon.arlott.org.uk>
Date: Tue, 01 May 2007 18:14:09 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-dvb@linuxtv.org
Subject: Re: [PATCH] dvb-core: Handle failures to create devices
References: <463774FE.9030104@simon.arlott.org.uk>
In-Reply-To: <463774FE.9030104@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/07 18:12, Simon Arlott wrote:
> dvb_class is NULL, this runs dvb_init using subsys_initclass instead of 
> module_init.

That should of course be subsystem_initCALL not "initclass".

-- 
Simon Arlott
