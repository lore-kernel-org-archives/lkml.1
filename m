Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbXFMPo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbXFMPo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbXFMPot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:44:49 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34781 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758066AbXFMPos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:44:48 -0400
Date: Wed, 13 Jun 2007 17:44:44 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Islam Amer <pharon@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: USB remote control missing keycodes
In-Reply-To: <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706131741420.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro> 
 <1181563063.19258.11.camel@iamer-laptop>  <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
  <1181743734.6163.1.camel@iamer-laptop>  <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
 <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Dmitry Torokhov wrote:

> Actually this one does not need hidbus and can be easily handled from 
> userspace now that we have setkeycodes support for HID.

Sure, thanks for reminding.

Islam, if you'd like to write an userspace 'driver' (really trivial 
few-liner) for the missing keys, you can use a new functionality in recent 
kernels, which allows you to use EVIOCSKEYCODE ioctl() on evdev to create 
a proper mapping between the usage codes that are not handled by 
hid-input, and keycodes.

-- 
Jiri Kosina
