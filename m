Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab0BYS4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:56:09 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46712 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab0BYS4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:56:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bU0SFjm9jbbJXCCdJMKvl0iCtyLpmuCcKZT0Oo3UsvxdHJSBAgk06Aqr27hGxyV3BF
         BFwK0BQOa4IsEBtNVZXlk+n37Fcp2jbLFcr8cEeSFiq/KIHWkebcEndnnqHXoP7VYz25
         WK3N5DMHpgUvEwg5YvK6/94kBDZ1Cr+H3rHJ4=
Date: Thu, 25 Feb 2010 20:55:58 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       HIRANO Takahito <hiranotaka@zng.info>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Miroslav Sustek <sustmidown@centrum.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/07] kernel.h int_sqrt cleanup
Message-ID: <20100225185557.GC3305@core2>
References: <20100225155419.GA2724@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225155419.GA2724@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 11:54:19PM +0800, Dave Young wrote:
> int_sqrt in kernel.h should be put into a standalone head file

> +extern unsigned long int_sqrt(unsigned long);

Come on, header for just one function.
