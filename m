Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbZATWGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbZATWGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762133AbZATWGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:06:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760878AbZATWGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:06:19 -0500
Date: 20 Jan 2009 22:24:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Message-ID: <AuEeLWHZjFB@christoph>
In-Reply-To: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Subject: Re: get_task_comm() not exported?
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18PdUyP79GHsuAvFUHH4aVxdXZy8IKhBoFOSp2
 C+S99gC9ITJIDSYyxgciaUNbOYrWPE0TwH3mCWnoB/K++UeW1Q
 wQocc0+lezh1ueEUPnyPkuzFHkz5crdk+ZQL5HtBSk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on 19 Jan 09 at 07:36, KOSAKI Motohiro wrote:
>> is there any reason why get_task_comm() is not exported in fs/exec.c?

> In general, the only function of anybody necessarity explained is exported.
> if you want to export get_task_comm(), you need to explain reasonable
> reason.

It's nothing that important: just want to print the executable name to the  
logs during error handling. get_task_comm() is the required accessor  
function.

http://lirc.cvs.sourceforge.net/viewvc/lirc/lirc/drivers/lirc_dev/lirc_dev.c?revision=1.70&view=markup

Cheers,
Christoph
