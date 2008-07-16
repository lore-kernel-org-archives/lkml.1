Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbYGPOAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbYGPOAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbYGPOAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:00:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:4887 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490AbYGPOAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding:from;
        b=atlNsXKS3FkW+JUsIUgz77t2HeQ7t50OI2WYH7nxr9ATnG7wAc+AN521ttQk7z2RTk
         DaWtvPtf/wrWkkATBgwCzFlUIxjBXqrcDdg9lsIODQOaUjauRu40+OyZksuSUC7Kiq9e
         2JeBv9eIL+y+U+wdzsQ3ABgeII/82Lsf5gSXE=
Message-ID: <487DFEE7.4030308@bellsouth.net>
Date: Wed, 16 Jul 2008 09:00:07 -0500
Reply-To: jacliburn@bellsouth.net
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Eric Dumazet <dada1@cosmosbay.com>, Ian Jeffray <ian@jeffray.co.uk>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>, csnook@redhat.com,
       jeff@garzik.org
Subject: Re: sendfile() broken with 2.6.26 + Apache 2 ?
References: <487CD7A7.2080800@jeffray.co.uk> <487D893A.5080207@cosmosbay.com>	 <487DA388.3030104@jeffray.co.uk> <487DBA74.3090800@cosmosbay.com>	 <487DF9EC.9060202@bellsouth.net> <84144f020807160641u32dac56fq9b9a30f6e32a27ca@mail.gmail.com>
In-Reply-To: <84144f020807160641u32dac56fq9b9a30f6e32a27ca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: "J. K. Cliburn" <jcliburn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Wed, Jul 16, 2008 at 4:38 PM, J. K. Cliburn <jcliburn@gmail.com> wrote:
>>> Yes, maybe related to commit 9d90fb1ac9d97da86e24d9ea947bf2a2f333829a
>>> In this patch, Jay Cliburn enabled TSO by default for atl1 driver.
>>>
>>> This might be a driver problem, or a generic sendfile() problem, I dont
>>> know...
>> I'm currently traveling and unable to delve into this issue and its relation
>> to the atl1 driver.  I should be able to look at it this weekend when I get
>> back home.
> 
> Ehh... shouldn't we disable atl1 TSO by default for -stable, then?

Based upon my inability to look at the problem for a couple more days?



