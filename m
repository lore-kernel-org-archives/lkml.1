Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbYBTVzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbYBTVzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYBTVzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:55:41 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:1497 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYBTVzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:55:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sItKhpAgFoeIaf4lVizU69dk1BmaPDmlkJpdz1bTKbtEzaNzrMXak7D2laLZ2PuTlsooahymLt/chyTB7c3xJJxATH7Ynf2/3UGkgIC6BP9Pmwm4HcV1y4WBo3RKd8drw+yroeXcIGpIiP6PWC8yPtGN9jCCnR1hW7oGSpRcRIY=
Message-ID: <86802c440802201355v260e8491k2e0832c5f12ebb39@mail.gmail.com>
Date: Wed, 20 Feb 2008 13:55:38 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Brice Goglin" <Brice.Goglin@inria.fr>
Subject: Re: Purpose of numa_node?
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Mundt" <lethal@linux-sh.org>,
       "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <47B33C56.3070502@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47A11ACD.1090400@redhat.com> <20080131074045.GA13788@linux-sh.org>
	 <47A1D03A.3020508@inria.fr>
	 <86802c440801311329h67a79139xa33994e2cc116781@mail.gmail.com>
	 <47A23F1C.7080809@inria.fr>
	 <86802c440801311342y16ff7c7eib28bf1c576be7075@mail.gmail.com>
	 <86802c440801311535v2bb9977ma884129662c9a2d5@mail.gmail.com>
	 <47B33C56.3070502@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:52 AM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
>  /sys/devices/pci0000:40/0000:40:0f.0/numa_node    1
>  /sys/devices/pci0000:40/0000:40:10.0/numa_node    1
>  /sys/devices/pci0000:40/0000:40:11.0/numa_node    1
>  /sys/devices/pci0000:40/0000:40:12.0/numa_node    1
>  /sys/devices/pci0000:40/0000:40:12.0/0000:51:00.0/numa_node    1
>  /sys/devices/pci0000:40/0000:40:13.0/numa_node    1
>
>  The 5 last lines above would report 0 instead of 1 with an older kernel.
>  Everything looks correct now (0000:40 is the second PCIe bus and it is
>  attached to socket #1).
>
>  Thanks a lot, Yinghai! Are you planning to merge these patches in the
>  near future? 2.6.26?
>
ingo put them in x86.git#testing

please check
http://people.redhat.com/mingo/x86.git/README
to get that.

YH
