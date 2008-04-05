Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbYDEMHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYDEMHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 08:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYDEMHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 08:07:43 -0400
Received: from tim.rpsys.net ([194.106.48.114]:59612 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbYDEMHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 08:07:42 -0400
Subject: Re: Clarifying platform_device_unregister
From: Richard Purdie <rpurdie@rpsys.net>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <45a44e480804011857v39e00f3ck53803cd43c34c7b0@mail.gmail.com>
References: <45a44e480803311814q22bc85dbx9a7d128d84b7db08@mail.gmail.com>
	 <20080401051947.GD18041@anvil.corenet.prv>
	 <45a44e480804010047m36a9b8e3p97910308ed5677fb@mail.gmail.com>
	 <20080401104533.ZZRA012@mailhub.coreip.homeip.net>
	 <45a44e480804011857v39e00f3ck53803cd43c34c7b0@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 05 Apr 2008 13:07:33 +0100
Message-Id: <1207397253.5021.23.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 21:57 -0400, Jaya Kumar wrote:
> I also have a followup. Does corgi/spitz_pm need to manage the module
> refcount of sharpsl-pm? I couldn't find any platform device code that
> manages the refcount of the platform driver that it binds them to. So
> I suspect this means that platform devices must do the try_module_get
> stuff themselves. Out of curiosity, what's the reason for not doing
> this inside the base/platform.c code?

I don't think any refcount is needed since corgi/spitz_pm refer to
functions in sharpsl-pm and therefore sharpsl-pm will always be around
as long as corgi/spitz_pm is.

Regards,

Richard

