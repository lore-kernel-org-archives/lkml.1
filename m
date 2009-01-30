Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZA3FE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZA3FE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 00:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZA3FEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 00:04:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:33848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZA3FEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 00:04:48 -0500
Date: Thu, 29 Jan 2009 21:04:35 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v2)
Message-ID: <20090129210435.4ca393c4@infradead.org>
In-Reply-To: <1233282702-6274-1-git-send-email-tom.leiming@gmail.com>
References: <1233282702-6274-1-git-send-email-tom.leiming@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 10:31:42 +0800
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch renames driver_probe_done to driver_wait_probe_done,
> and make it wait on condition of probing done to remove
> polling for it in fs initialization. Also add
> driver_wait_probe_done_and_dev_appear(name) to allow callers
> to wait until all probing is done AND until the device @name
> exists.

>  /**
> + * driver_wait_probe_done_and_dev_appear
> + * wait until the probe sequence is finished _and_ the dev @name
> appears.

Hi,

sorry to be the bad guy, but I think you turned the "either one" into a
"both".... so this isn't going to work ;(

unless I'm just too tired and miss something subtle, but I am pretty
sure DeMorgan does not work this way :)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
