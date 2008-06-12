Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbYFLSh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbYFLSh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYFLShw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:37:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYFLShv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:37:51 -0400
Message-ID: <48516CF2.106@zytor.com>
Date: Thu, 12 Jun 2008 11:37:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Altobelli <david.altobelli@hp.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HP iLO driver
References: <20080612182308.GA1091@ldl.fc.hp.com>
In-Reply-To: <20080612182308.GA1091@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Altobelli wrote:
> A driver for the HP iLO/iLO2 management processor, which allows userspace
> programs to query the management processor.  Programs can open a channel
> to the device (/dev/hpilo_ccbN), and use this to send/receive queries.  
> The O_EXCL open flag is used to indicate that a particular channel cannot
> be shared between processes.  This driver will replace various packages
> HP has shipped, including hprsm and hp-ilo.

Wouldn't /dev/hpilo/ccbN be a more appropriate namespace?

	-hpa
