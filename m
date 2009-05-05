Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZEEL3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZEEL3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZEEL3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:29:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:37625 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751631AbZEEL3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:29:21 -0400
X-Authenticated: #54312696
X-Provags-ID: V01U2FsdGVkX1+sidwxL7KsMUq09yIPha6xOhtY++qmnO/54WFLXu
	3T6bG1WuD2p0gR
Date: Tue, 05 May 2009 13:29:22 +0200 (CEST)
Message-Id: <20090505.132922.236842394.wl@gnu.org>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: some kernel issues
From: Werner LEMBERG <wl@gnu.org>
In-Reply-To: <21d7e9970905050415s19201731s4907824ec340e8ee@mail.gmail.com>
References: <21d7e9970905050344x2a92f9c6l8569b68bff905370@mail.gmail.com>
	<20090505.130225.42780711.wl@gnu.org>
	<21d7e9970905050415s19201731s4907824ec340e8ee@mail.gmail.com>
X-Mailer: Mew version 6.2.50 on Emacs 22.3.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> CONFIG_DRM_I915_KMS
>>
>> Uuuuh, completely undocumented.  Thanks!  Will check soon.
>>
> 
> Huh?
> 
>  Choose this option if you want kernel modesetting enabled by
>  default, and you have a new enough userspace to support this.
>  Running old userspaces with this enabled will cause pain.  Note
>  that this causes the driver to bind to PCI devices, which precludes
>  loading things like intelfb.

Mea culpa, sorry.  I did a grep for `CONFIG_DRM_I915_KMS'.  Now I know
that I have to omit the `CONFIG_' part.


    Werner
