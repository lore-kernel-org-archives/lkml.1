Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbXFIMce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbXFIMce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 08:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbXFIMcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 08:32:25 -0400
Received: from relay4.usu.ru ([194.226.235.39]:37098 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbXFIMcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 08:32:24 -0400
Message-ID: <466A9DDD.2040107@ums.usu.ru>
Date: Sat, 09 Jun 2007 18:32:29 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, daniel.ritz@gmx.ch,
       linux@brodo.de
Subject: Re: Rules on how to use sysfs in userspace programs
References: <20070608203637.GA9259@kroah.com>
In-Reply-To: <20070608203637.GA9259@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> - Do not use libsysfs
>   It makes assumptions about sysfs which are not true. Its API does not
>   offer any abstraction, it exposes all the kernel driver-core
>   implementation details in its own API. Therefore it is not better than
>   reading directories and opening the files yourself.
>   Also, it is not actively maintained, in the sense of reflecting the
>   current kernel-development. The goal of providing a stable interface
>   to sysfs has failed, it causes more problems, than it solves. It
>   violates many of the rules in this document.

The problem is that even on ftp.kernel.org there are packages like 
pcmciautils that still link to libsysfs and contain things like #define 
PATH_TO_SOCKET "/sys/class/pcmcia_socket/". Are they expected to be fixed?

-- 
Alexander E. Patrakov
