Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYGGJJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYGGJJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 05:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYGGJJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 05:09:28 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:55349 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYGGJJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:09:27 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.26-rc8-git2 - powerpc - circular locking dependency detected with net/ehea driver
Date: Mon, 7 Jul 2008 10:08:08 +0100
User-Agent: KMail/1.8.2
Cc: kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, kernel-testers@vger.kernel.org,
       jgarzik@pobox.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
References: <486A2553.1090207@linux.vnet.ibm.com>
In-Reply-To: <486A2553.1090207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807071108.09616.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

where you able to reproduce this problem with the patches applied
we posted on friday?

Regards,
Jan-Bernd

On Tuesday 01 July 2008 14:38, Kamalesh Babulal wrote:
> Hi,
> 
> circular locking dependency is detected, while booting the
> powerpc box with the 2.6.26-rc8-git2 kernel.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.26-rc8-git2 #1
> -------------------------------------------------------
