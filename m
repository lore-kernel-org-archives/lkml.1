Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZBEACs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZBEACs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZBEACi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:02:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42839 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZBEACh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:02:37 -0500
Message-ID: <498A2C90.2000208@jp.fujitsu.com>
Date: Thu, 05 Feb 2009 09:02:24 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Krishna Kothapalli <krishna_sunitha@hotmail.com>
CC: ebiederm@xmission.com, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       achiang@hp.com, djwong@us.ibm.com, xyzzy@speakeasy.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: state of pci express hotplug
References: <m1fxj06js8.fsf@fess.ebiederm.org> <4986581F.7060704@jp.fujitsu.com>   <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>   <49879508.4090801@jp.fujitsu.com>   <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl> <BAY111-W9013DA1F63973F9E7F8DF88C30@phx.gbl> <49892CDE.9040305@jp.fujitsu.com> <BAY111-W205B70ED6B226F2F9D8E2088C30@phx.gbl>
In-Reply-To: <BAY111-W205B70ED6B226F2F9D8E2088C30@phx.gbl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> o Details about the steps to reproduce the problem.
> 
>   - boot the box with 2.6.28.3
>   -   # /sbin/modprobe pciehp pciehp_debug
>   - lspci 
>   - Insert the PCI express card on the hot swap slot and wait for 2 mins
>   - lspci <-- this does not show the PCI express device 
>   (The same device shows up in lspci and sysfs during cold boot ) 

Could you try below after inserting the device?

With pciehp:

	# echo 1 > /sys/bus/pci/slots/96/power

With acpiphp:

	# echo 1 > /sys/bus/pci/slots/2/power

Thanks,
Kenji Kaneshige


