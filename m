Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbXLDIFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbXLDIFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXLDIF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:05:27 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52641 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbXLDIF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:05:26 -0500
Date: Tue, 4 Dec 2007 10:05:24 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Dave Young <hidave.darkstar@gmail.com>
cc: petero2@telia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pktcdvd : add kobject_put when kobject register fails
In-Reply-To: <a8e1da0712040000n7f94c5bbk3e6526ed395d62d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712041004250.20088@sbz-30.cs.Helsinki.FI>
References: <20071204013144.GA2850@darkstar.lan> 
 <84144f020712032345r6fc1f44cg5f35b23bdb8191be@mail.gmail.com>
 <a8e1da0712040000n7f94c5bbk3e6526ed395d62d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, 4 Dec 2007, Dave Young wrote:
> the kobject reference is get in kobject_init, and then kobject_add, if
> kobject_add fail, it will only cleanup the reference got by itsself.
> 
> This topic is discussed in:
> http://lkml.org/lkml/2007/11/30/9

Ok, thanks! Please the explanation to the changelog too.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka
