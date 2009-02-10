Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZBJRXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZBJRXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZBJRXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:23:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:54901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZBJRXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:23:31 -0500
Date: Tue, 10 Feb 2009 18:23:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mchehab@infradead.org
Subject: Re: [PATCH 2/3] use the new request_module_nowait() in the hid
 driver
In-Reply-To: <20090208104240.3405903f@infradead.org>
Message-ID: <alpine.LNX.1.10.0902101822280.11630@jikos.suse.cz>
References: <20090208104201.6124ab6a@infradead.org> <20090208104240.3405903f@infradead.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Arjan van de Ven wrote:

> From b8c36ec88e272ba2e755e6104579f1e751ee81f8 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 1 Feb 2009 12:02:39 -0800
> Subject: [PATCH] use the new request_module_nowait() in the hid driver
> 
> Now that there is a request_module_nowait(), use it in the hid driver.
> This gets rid of a kernel thread, and also greatly simplifies the code...
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>

Rusty, could you please take this altogether with the patch introducing 
request_module_nowait() itself?

Thanks,

-- 
Jiri Kosina
SUSE Labs
