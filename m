Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbXKMUpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbXKMUpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760992AbXKMUpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:45:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51528 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759591AbXKMUpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:45:22 -0500
Date: Tue, 13 Nov 2007 12:43:26 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Joonwoo Park" <joonwpark81@gmail.com>
Cc: "'David Miller'" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       "'Dave Johnson'" <djohnson+linux-kernel@sw.starentnetworks.com>,
       <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous
 mode
Message-ID: <20071113124326.51c3607c@freepuppy.rosehill>
In-Reply-To: <47365200.0f10240a.0686.2173@mx.google.com>
References: <47365200.0f10240a.0686.2173@mx.google.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2007 09:51:20 +0900
"Joonwoo Park" <joonwpark81@gmail.com> wrote:

> IMHO even though netdevice is in the promiscuous mode, we should receive all of ingress packets.
> This disable the vlan filtering feature when a vlan hw accel configured e1000 device goes into promiscuous mode.
> This make packets visible to sniffers though it's not vlan id of itself.
> Any check, comments will be appreciated.
> Thanks.
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

Promiscuous has other uses such as bridging. Would this patch break any
existing users startup scripts?
