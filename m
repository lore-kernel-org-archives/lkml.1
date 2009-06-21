Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbZFUM4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbZFUM4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZFUM4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 08:56:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33645 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbZFUM4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 08:56:34 -0400
Message-ID: <4A3E2E17.4010305@redhat.com>
Date: Sun, 21 Jun 2009 15:56:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mingo@elte.hu, mst@redhat.com, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH 0/4] irqfd fixes/enhancements
References: <20090618173534.24119.95115.stgit@dev.haskins.net>
In-Reply-To: <20090618173534.24119.95115.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2009 08:44 PM, Gregory Haskins wrote:
> (Applies to kvm.git/master:c27b64a0)
>
> The following series represents my queue of fixes for issues in irqfd,
> which include enhancements to eventfd.  This is a respin of the patches
> originally proposed yesterday, called "[KVM-RFC PATCH 0/2] eventfd
> enhancements for irqfd/iosignalfd", which you can find a link to the thread
> here:
>
> http://www.gossamer-threads.com/lists/linux/kernel/1091852
>
> Aside from introducing a few minor fixes (patches 1/4, 2/4), the general
> solution for module reference counting has been extracted from the
> (controversial) SRCU enhancement.  We can address the SRCU topic at a later
> time.  For now, fixing the race condition is a higher priority item IMO.
> Hopefully, this more focused series is more palatable for the
> reviewers/maintainers involved.
>    

Applied 1-2, thanks.

-- 
error compiling committee.c: too many arguments to function

