Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZJDK04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZJDK04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 06:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZJDK0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 06:26:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbZJDK0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 06:26:54 -0400
Message-ID: <4AC87851.30501@redhat.com>
Date: Sun, 04 Oct 2009 12:26:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: add io services to xinterface
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201932.4014.91402.stgit@dev.haskins.net>
In-Reply-To: <20091002201932.4014.91402.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2009 10:19 PM, Gregory Haskins wrote:
> We want to add a more efficient way to get PIO signals out of the guest,
> so we add an "xioevent" interface.  This allows a client to register
> for notifications when a specific MMIO/PIO address is touched by
> the guest.  This is an alternative interface to ioeventfd, which is
> performance limited by io-bus scaling and eventfd wait-queue based
> notification mechanism.  This also has the advantage of retaining
> the full PIO data payload and passing it to the recipient.
>
>    

Can you detail the problems with io-bus scaling and eventfd 
wait-queues?  Maybe we should fix these instead.

-- 
error compiling committee.c: too many arguments to function

