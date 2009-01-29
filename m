Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbZA2PZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbZA2PZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZA2PZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:25:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:40478 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZA2PZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:25:43 -0500
Date: Thu, 29 Jan 2009 07:25:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done
Message-ID: <20090129072543.1302344c@infradead.org>
In-Reply-To: <1233242110-5422-1-git-send-email-tom.leiming@gmail.com>
References: <1233242110-5422-1-git-send-email-tom.leiming@gmail.com>
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

On Thu, 29 Jan 2009 23:15:10 +0800
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch renames driver_probe_done to driver_probe_wait_done,
> and make it wait on condition variable of probe done to remove
> polling for it in fs initialization.
> 

I do not see where you add the wake_up() for waking up the wait queue...
.... are you sure this is going to work ?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
