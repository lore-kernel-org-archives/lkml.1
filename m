Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbZAXIeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbZAXIeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 03:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZAXIeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 03:34:08 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:2889 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZAXIeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 03:34:07 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=4cncSJfDi2vJL7ohYqEA:9 a=Tmmt65Crnv0o-Rn7w3JlVnNoE78A:4 a=F3aLDEtscPAA:10 a=O7oCZswB7c4A:10
Message-ID: <497AD27B.8000204@shaw.ca>
Date: Sat, 24 Jan 2009 02:34:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Nathan <nathan.stocks@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Did my SATA drive fail? What should I do?
References: <96c9d6a80901221431u16dbf135ife7b59f7b38cb8fa@mail.gmail.com>
In-Reply-To: <96c9d6a80901221431u16dbf135ife7b59f7b38cb8fa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan wrote:
> First off:  Hi!  I'm new to this list.  Googling some of the errors in
> my logs brought up several posts to this list, none of which led to
> any obvious resolutions, so I thought I'd try joining the list...
> 
> I have a linux server[1] that has been acting as an asterisk pbx for
> about three months without a problem.  Today, the SATA hard drive
> suddenly went into read-only mode (!?).  Reading seems to work just
> fine, as I've ssh'd in and looked at a bunch of files, including
> /var/log/messages [2].
> 
> Is this just my hardware failing?  Could this a kernel bug?
> Recommendations?  I would just reboot the thing, but asterisk is still
> successfully handling dozens of calls right now, despite not being
> able to write to the disk...
> 
> [1] # uname -a
> Linux phoneserver3 2.6.25-gentoo-r7 #2 SMP Thu Oct 16 20:59:53 MDT
> 2008 x86_64 Intel(R) Xeon(R) CPU E5410 @ 2.33GHz GenuineIntel
> GNU/Linux
> 
> [2] (last several lines from /var/log/messages)
> 
> Jan 22 14:43:09 phoneserver3 dhcpd: DHCPDISCOVER from
> 00:04:f2:1e:7e:21 via eth2: network 10.254.254/24: no free leases
> Jan 22 14:43:09 phoneserver3 dhcpd: DHCPDISCOVER from
> 00:04:f2:1e:7c:6b via eth2: network 10.254.254/24: no free leases
> Jan 22 14:43:35 phoneserver3 dhcpd: DHCPDISCOVER from
> 00:04:f2:1e:0d:47 via eth2: network 10.254.254/24: no free leases
> Jan 22 14:43:36 phoneserver3 dhcpd: DHCPDISCOVER from
> 00:1f:28:83:00:80 via eth2: network 10.254.254/24: no free leases
> Jan 22 14:43:41 phoneserver3 ata1.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x0
> Jan 22 14:43:41 phoneserver3 ata1.00: BMDMA stat 0x25
> Jan 22 14:43:41 phoneserver3 ata1.00: cmd
> ca/00:20:00:7c:ef/00:00:00:00:00/ef tag 0 dma 16384 out
> Jan 22 14:43:41 phoneserver3 res 51/10:20:00:7c:ef/00:00:00:00:00/ef
> Emask 0x81 (invalid argument)
> Jan 22 14:43:41 phoneserver3 ata1.00: status: { DRDY ERR }
> Jan 22 14:43:41 phoneserver3 ata1.00: error: { IDNF }

Most likely this is the disk failing. It's reporting the sector wasn't 
found during a write operation.
