Return-Path: <linux-kernel-owner+w=401wt.eu-S1422643AbXBUQPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422643AbXBUQPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161327AbXBUQPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:15:09 -0500
Received: from terminus.zytor.com ([192.83.249.54]:55252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161331AbXBUQPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:15:07 -0500
Message-ID: <45DC6FD6.4040005@zytor.com>
Date: Wed, 21 Feb 2007 08:14:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
References: <20070216185230.GO8882@enneenne.com> <45DA6354.3000305@zytor.com> <20070221120426.GJ4641@enneenne.com>
In-Reply-To: <20070221120426.GJ4641@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
> 
> The problem is that sometimes you cannot have a filedescriptor at
> all. Think about a PPS source connected with a CPU's GPIO pin. You
> have no filedes to use and defining one just for a PPS source or for a
> class of PPS sources, I think, is a non sense.
> 

If you have a kernel driver at all, then it makes perfect sense.  If you 
don't have a kernel driver at all, then it's irrelevant to the 
linux-kernel discussion.

> RFC simply doesn't consider the fact that you can have a PPS source
> __without__ a filedes connected with, and a single filedes is
> considered __always__ connected with a single PPS source.

That's the Unix way.

	-hpa

