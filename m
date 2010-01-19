Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198Ab0ASSma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0ASSma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310Ab0ASSm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:42:29 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:47154 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0ASSm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:42:28 -0500
Date: Tue, 19 Jan 2010 10:41:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 19 (vhost_net)
Message-Id: <20100119104139.2ec9164b.randy.dunlap@oracle.com>
In-Reply-To: <20100119181041.ab55f645.sfr@canb.auug.org.au>
References: <20100119181041.ab55f645.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B55FCFD.0169:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010 18:10:41 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100118:


When CONFIG_TUN is not enabled:

drivers/built-in.o: In function `get_socket':
net.c:(.text+0x2899a3): undefined reference to `tun_get_socket'


so VHOST_NET can either depend on TUN or select TUN, but if it
selects TUN, it will also need to select CRC32.

---
~Randy
