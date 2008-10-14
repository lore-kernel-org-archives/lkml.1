Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYJNUaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYJNUaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYJNUam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:30:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:44671 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbYJNUal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:30:41 -0400
Date: Tue, 14 Oct 2008 22:30:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Jiri Kosina <jikos@jikos.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Adds a driver for Bright ABNT2 Brazilian keyboard
In-Reply-To: <20081014110913.22f28ea7@pedra.chehab.org>
Message-ID: <alpine.LNX.1.10.0810142228230.26779@jikos.suse.cz>
References: <20081014110913.22f28ea7@pedra.chehab.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Mauro Carvalho Chehab wrote:

> This keyboard needs to reset the LEDS during probe.

Thanks. We also need to have additional entry added into 
drivers/hid/hid-dummy.c, because of the COMPAT fun. I will fix this up and 
apply the patch.

Thanks,

-- 
Jiri Kosina
SUSE Labs
