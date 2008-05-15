Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYEOPdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYEOPdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbYEOPcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:32:51 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:33058
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbYEOPcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:32:50 -0400
Message-ID: <482C579F.4030509@qumranet.com>
Date: Thu, 15 May 2008 18:32:47 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
References: <1209565906-9019-1-git-send-email-markmc@redhat.com>	 <1210624663.14409.20.camel@muff> <48294776.3010504@qumranet.com>	 <200805141607.26306.rusty@rustcorp.com.au>  <482AAA0F.2020607@qumranet.com> <1210865380.16012.15.camel@muff>
In-Reply-To: <1210865380.16012.15.camel@muff>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> I think Rusty is speaking from the POV of the guest driver - i.e. that
> virtio_net should never disable notifications on the xmit queue using
> disable_cb()?
>
> Sounds like you think agree, but that the host side should throttle the
> rate of xmit notifications?
>   

Yes.

-- 
error compiling committee.c: too many arguments to function

