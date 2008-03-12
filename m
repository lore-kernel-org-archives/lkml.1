Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYCLXHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYCLXHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYCLXHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:07:12 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:58076 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYCLXHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:07:11 -0400
Date: Thu, 13 Mar 2008 00:07:04 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Chr <chunkeey@web.de>
cc: Samuel Tardieu <sam@rfc1149.net>,
       device-mapper development <dm-devel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
In-Reply-To: <200803122053.13265.chunkeey@web.de>
Message-ID: <alpine.DEB.1.00.0803130003110.5593@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com> <2008-03-12-19-03-51+trackit+sam@rfc1149.net> <200803122053.13265.chunkeey@web.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Chr wrote:
> http://lkml.org/lkml/2008/3/11/377
> (BTW: I'm still bisecting it... can somebody please confirm that 2.6.24-git17
> http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.24-git17.bz2
> was the _last_ "good" one?)

Hm, -git17 locked up hard when trying to access the device mapper
(just like -rc1), not even sysrq was usable any more. Sadly, 
nothing was logged to the disks/network. Will try earlier snapshots 
then. And yes, this resyncing of the md devices after an unclean shutdown 
is a real pita right now...

Thanks for reporting!
Christian.
-- 
BOFH excuse #197:

I'm sorry a pentium won't do, you need an SGI to connect with us.
