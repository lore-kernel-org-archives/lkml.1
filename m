Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbZF1MF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbZF1MF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 08:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZF1MFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 08:05:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbZF1MFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 08:05:47 -0400
Message-ID: <4A475CF3.1070604@redhat.com>
Date: Sun, 28 Jun 2009 15:07:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
References: <20090623150008.GA21059@redhat.com> <4A4184C3.6060503@novell.com> <20090624084901.GB22865@redhat.com> <20090625110812.GA6487@redhat.com> <4A435F28.3000301@novell.com> <20090625115403.GA7079@redhat.com> <4A4368A4.8030401@novell.com> <20090625123757.GA7121@redhat.com> <4A437564.6060308@novell.com> <20090625131633.GA7221@redhat.com> <4A43795D.1080501@novell.com>
In-Reply-To: <4A43795D.1080501@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2009 04:19 PM, Gregory Haskins wrote:
> Indeed.  I will put something together.
>
> We should consider merging the io_bus cleanup I have for deregister
> support ASAP as well.
>
>    

If it makes things easier, we can also introduce a rwsem as an 
intermediary step.

-- 
error compiling committee.c: too many arguments to function

