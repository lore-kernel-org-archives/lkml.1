Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYBTQvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYBTQvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYBTQut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:50:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48779 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYBTQus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:50:48 -0500
Message-ID: <47BC5A62.2030701@garzik.org>
Date: Wed, 20 Feb 2008 11:50:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>
Subject: Re: [PATCH] ehea: add kdump support
References: <47B30A49.8080404@de.ibm.com>
In-Reply-To: <47B30A49.8080404@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> This patch adds kdump support to the ehea driver. As the firmware doesn't free
> resource handles automatically, the driver has to run an as simple as possible
> free resource function in case of a crash shutdown. The function iterates over
> two arrays freeing all resource handles which are stored there. The arrays are
> kept up-to-date during normal runtime. The crash handler fn is triggered by the
> recently introduced PPC crash shutdown reg/unreg functions.
> 
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> 
> ---
>  drivers/net/ehea/ehea.h      |   34 +++++-
>  drivers/net/ehea/ehea_main.c |  281 ++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 290 insertions(+), 25 deletions(-)

applied


