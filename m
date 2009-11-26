Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZKZUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZKZUoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 15:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZKZUoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 15:44:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZKZUoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 15:44:18 -0500
Date: 26 Nov 2009 21:37:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: mchehab@redhat.com
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: superm1@ubuntu.com
Message-ID: <BDcc3mfojFB@christoph>
In-Reply-To: <4B0E765C.2080806@redhat.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+AzTYSKZXPaklhDHzKcjm9YgZaTl4nM77dFpD
 9iTP0KBv+yFJTar92BWi/YEtH69dzMLAEDA6Qs+Ed5vox/dF1L
 hghiSCSoyjc11zGNzqVtvCA4PlOMmiG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

on 26 Nov 09 at 10:36, Mauro Carvalho Chehab wrote:
[...]
> lircd supports input layer interface. Yet, patch 3/3 exports both devices
> that support only pulse/space raw mode and devices that generate scan
> codes via the raw mode interface. It does it by generating artificial
> pulse codes.

Nonsense! There's no generation of artificial pulse codes in the drivers.
The LIRC interface includes ways to pass decoded IR codes of arbitrary  
length to userspace.

Christoph
