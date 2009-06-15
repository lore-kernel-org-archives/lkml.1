Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbZFOP5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbZFOP5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762883AbZFOP44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:56:56 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:23905 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZFOP44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:56:56 -0400
Message-ID: <4A366E67.4040300@oracle.com>
Date: Mon, 15 Jun 2009 08:53:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: How to unset CONFIG_SERIO_I8042 on x86?
References: <1244915236.3288.7.camel@localhost.localdomain>
In-Reply-To: <1244915236.3288.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A366F32.028C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> Is it possible? Does it make sense?

Enabled CONFIG_EMBEDDED, then disable KEYBOARD_ATKBD and
disable MOUSE_PS2, then you can disable SERIO_I8042.


Is the Macbook all USB for input devices?


> I always get this message at boot up on my macbook pro:
> 
> [    0.929828] PNP: No PS/2 controller found. Probing ports directly.
> [    0.930761] i8042.c: No controller found.
> [    0.931038] mice: PS/2 mouse device common for all mice
> 
> Or please make these messages warnings only, so I don't see them with
> kernel option quiet.


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
