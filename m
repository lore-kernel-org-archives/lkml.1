Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267Ab0AQMlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab0AQMlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057Ab0AQMli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:41:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0AQMlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:41:37 -0500
Message-ID: <4B530578.80003@redhat.com>
Date: Sun, 17 Jan 2010 14:41:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [patch] eventfd - allow atomic read and waitqueue remove
References: <alpine.DEB.2.00.1001130927590.2775@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.1001130927590.2775@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 07:34 PM, Davide Libenzi wrote:
> KVM needs a wait to atomically remove themselves from the eventfd ->poll()
> wait queue head, in order to handle correctly their IRQfd deassign
> operation.
> This patch introduces such API, plus a way to read an eventfd from its
> context.
> Andrew, they prefer to have this go through Avi's KVM tree, in order to
> keep dependencies localized. So you just ignore this.
> Avi, this fixes a few checkpatch warnings, so you should get this instead
> of the one posted previously.
>
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

