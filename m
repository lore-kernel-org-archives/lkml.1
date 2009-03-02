Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbZCBQWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbZCBQWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZCBQVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:21:51 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:20538 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZCBQVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:21:51 -0500
Message-ID: <49AC0799.5060306@turknet.net.tr>
Date: Mon, 02 Mar 2009 18:21:45 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Failover Kernel
References: <49A659D0.2040903@turknet.net.tr>	 <200902261802.56612.diegocg@gmail.com>  <49A80796.2070208@turknet.net.tr> <1235749850.4718.1.camel@localhost.localdomain>
In-Reply-To: <1235749850.4718.1.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Mar 2009 16:21:47.0131 (UTC) FILETIME=[FBD31CB0:01C99B52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lubomir Rintel wrote:
>
> How is the backup kernel minimal? It is usually the very same kernel as
> the "primary" one. You can use the same initrd as well and do a full
> multiuser boot.
>
>   
Kdump's backup (in kdump terms, it is "Capture Kernel") kernel is with 
minimal set of features and modules (scsi drivers, network drivers etc.) 
to have small memory footprint and resources to just handle crash dump 
related things. So,it's not a full replacement of primary kernel. Also, 
the point is not to make boot when crash occured. The idea is to take 
control when a crash occured by backup kernel without any need to reboot.
