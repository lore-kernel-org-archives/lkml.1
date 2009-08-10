Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZHJWZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZHJWZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZHJWZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:25:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33278 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbZHJWZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:25:33 -0400
Message-ID: <4A809E32.6060206@zytor.com>
Date: Mon, 10 Aug 2009 15:24:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 1/2] export cpu_tlbstate to modules
References: <cover.1249930169.git.mst@redhat.com> <20090810185302.GB13924@redhat.com> <4A80979E.3080204@zytor.com> <20090810220613.GA17099@redhat.com>
In-Reply-To: <20090810220613.GA17099@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2009 03:06 PM, Michael S. Tsirkin wrote:
>> Wouldn't it be a *lot* better to move use_mm() from fs/aio.c into common
>> code, and export that instead?
> 
> That's easy too. What would a good place for it be?

Somewhere in mm/, presumably.  When in doubt, make it a new file...
	
	-hpa
