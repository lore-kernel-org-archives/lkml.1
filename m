Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0CAVIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:08:48 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:47292 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0CAVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:08:46 -0500
Message-ID: <4B8C2CC5.8000603@oracle.com>
Date: Mon, 01 Mar 2010 13:08:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for March 1 (bluetooth/hci_sysfs)
References: <20100301210210.c6f465e6.sfr@canb.auug.org.au>
In-Reply-To: <20100301210210.c6f465e6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B8C2CD5.003B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/10 02:02, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100226:
> 
> We are seeing conflicts migrate from being between 2 trees in linux-next
> to be between a tree and Linus' tree as things start to get merged.
> 
> 
> The net tree gained a conflict against Linus' tree.

static ssize_t inquiry_cache_read(struct file *file, char __user *userbuf,
						size_t count, loff_t *ppos)
{
	struct hci_dev *hdev = file->private_data;
	struct inquiry_cache *cache = &hdev->inq_cache;
	struct inquiry_entry *e;
	char buf[4096]; // <<<<<<<<<<<<<<<<<<<<<<<<<<< huh? don't do that on stack.
	int n = 0;


-- 
~Randy
