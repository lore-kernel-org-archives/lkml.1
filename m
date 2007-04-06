Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbXDFQyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbXDFQyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbXDFQym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:54:42 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:51388 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933325AbXDFQyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:54:41 -0400
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
From: James Bottomley <James.Bottomley@SteelEye.com>
To: dougg@torque.net
Cc: Andrew Burgess <aab@cichlid.com>, cebbert@redhat.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       aradford@gmail.com
In-Reply-To: <4616761F.2050905@torque.net>
References: <200704061551.l36FpWoV015751@cichlid.com>
	 <1175876096.3677.24.camel@mulgrave.il.steeleye.com>
	 <4616761F.2050905@torque.net>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 11:47:32 -0500
Message-Id: <1175878053.3677.32.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 12:32 -0400, Douglas Gilbert wrote:
> That last line should be:
>         request_buffer[7] = 10;	/* minimum size per SPC: 18 bytes */

Er, yes, I'm afraid when I see n-7 I always think n is the lenght, not n
is the last byte ...

James


