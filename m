Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYCUEVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYCUEVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYCUEVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:21:22 -0400
Received: from gw.goop.org ([64.81.55.164]:52470 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623AbYCUEVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:21:21 -0400
Message-ID: <47E336D6.4020807@goop.org>
Date: Thu, 20 Mar 2008 21:17:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: linux-kernel@vger.kernel.org,
       Christian Limpach <Christian.Limpach@xensource.com>
Subject: Re: [PATCH] xen blkfront: Delay wait for block devices until after
 the disk is added.
References: <1206005390-18306-1-git-send-email-markmc@redhat.com>
In-Reply-To: <1206005390-18306-1-git-send-email-markmc@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> From: Christian Limpach <Christian.Limpach@xensource.com>
>
> When the xen block frontend driver is built as a module the module load
> is only synchronous up to the point where the frontend and the backend
> become connected rather than when the disk is added.
>
> This means that there can be a race on boot between loading the module and
> loading the dm-* modules and doing the scan for LVM physical volumes (all
> in the initrd). In the failure case the disk is not present until after the
> scan for physical volumes is complete.
>   

Thanks, I've queued this.

    J
