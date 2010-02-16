Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0BPMew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:34:52 -0500
Received: from mail001.aei.ca ([206.123.6.130]:33558 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab0BPMev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:34:51 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 0/2] Provide a driver for the Apple Magic Mouse - opps
Date: Tue, 16 Feb 2010 07:34:47 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.32.8-crc; KDE/4.4.0; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
       linux-input@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <201002140922.42014.edt@aei.ca> <20100215071145.GA9135@core.coreip.homeip.net>
In-Reply-To: <20100215071145.GA9135@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002160734.47588.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010 02:11:46 Dmitry Torokhov wrote:
> Almost... you need to do hid_hw_stop() first and only then unregister
> input device, Otherwise if you unload the module while moving the mouse
> it is likely to still oops.

The exit routing for the module also has a hid_hw_stop.  Is it going to cause
problems when it gets called twice?

TIA
Ed
