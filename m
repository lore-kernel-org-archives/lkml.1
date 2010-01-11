Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054Ab0AKWYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0AKWYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785Ab0AKWYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:24:52 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:40516 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0AKWYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:24:51 -0500
Date: Mon, 11 Jan 2010 23:24:48 +0100
From: Bastian Blank <waldi@debian.org>
To: Ping Cheng <pingc@wacom.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jason Childs <oblivian@users.sourceforge.net>
Subject: Re: [PATCH 5/7] Input: wacom - Convert remaining ids, part two
Message-ID: <20100111222448.GA7959@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Ping Cheng <pingc@wacom.com>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jason Childs <oblivian@users.sourceforge.net>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org> <20100107182953.GA12985@wavehammer.waldi.eu.org> <6753EB6004AFF34FAA275742C104F952016A1329@wacom-nt10.wacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6753EB6004AFF34FAA275742C104F952016A1329@wacom-nt10.wacom.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please fix your MUA, it should break lines to below 80 characters.

On Mon, Jan 11, 2010 at 01:22:31PM -0800, Ping Cheng wrote:
> Can we only move the struct wacom_features definition to wacom_sys.c
> and leave the device specific wacom_features in wacom_wac.c?

The driver is so small. I don't see any reason to split that at all.

>                                                               Also
> leave the actual wacom_ids [] in wacom_wac.c as well since they are
> wacom specific stuff.

No, this are USB id mappings, Linux specific ones.

>                        We'd like to keep wacom specific stuff in
> wacom_wac.c/h, which hopefully can be shared among kernel releases.

The two parts are not properly seperated, none of them can stand on its
own. How exactly do you want to do that?

> BTW, the testing, led by Jason, got very positive feedbacks. There is
> no crash reported with your patch applied.

Why should there be any crashs? It is a simple restructuring.

While we are at it, why does this driver need this amount of hardcoding
of the values in the kernel anyway?

Bastian

-- 
Schshschshchsch.
		-- The Gorn, "Arena", stardate 3046.2
