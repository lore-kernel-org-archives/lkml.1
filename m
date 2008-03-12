Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbYCLQas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbYCLQas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYCLQa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:30:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11987 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYCLQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:30:24 -0400
Message-ID: <47D7F1D0.1030206@oracle.com>
Date: Wed, 12 Mar 2008 08:08:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH -mm] ne2: needs more 8390 support functions
References: <20080311095643.01cd3708.randy.dunlap@oracle.com> <20080312124412.6089948c@the-village.bc.nu>
In-Reply-To: <20080312124412.6089948c@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 11 Mar 2008 09:56:43 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> ne2 (MCA) needs both 8390.o and 8390p.o functions:
> 
> NAK - the two modules are alternatives nothing should use both - is 8390p
> not sufficient ?

8390p alone is not sufficient.
http://lkml.org/lkml/2008/3/11/243

-- 
~Randy
