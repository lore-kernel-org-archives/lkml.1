Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbYJMMar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbYJMMar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbYJMMah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:30:37 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6196 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755230AbYJMMag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:30:36 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2008 08:30:35 EDT
X-IronPort-AV: E=Sophos;i="4.33,403,1220220000"; 
   d="scan'208";a="16011443"
Date: Mon, 13 Oct 2008 14:20:29 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial Routing In the Kernel
Message-ID: <20081013122029.GE5070@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Prabhu Chawandi <prabhu.chavandi@gmail.com>,
	linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <241b8f7b0810130351v572730d8mb43e6df856e37f0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <241b8f7b0810130351v572730d8mb43e6df856e37f0b@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prabhu Chawandi, le Mon 13 Oct 2008 16:21:43 +0530, a écrit :
>   I wanted to know where exactly, in which file int the kernel, debug
> messages are routed to the serial console driver...

See calls to register_console in drivers/serial/*

Samuel
