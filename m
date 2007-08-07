Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbXHGG4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbXHGG4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXHGG4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:56:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:13674 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbXHGG4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CC+uDl+kgPbGMa0ajSjkpqujhzpOHjC0Iy3/4ytGx49Zw/qJ8cbQGJDWt63KupzwFykoJlNUodutI0riLOHoaUAmt4ZQFqE5tSbihEMamUYPO1DBzynflhoEtreqYH2mkd8Kpj0v1cQK+2e51vUZ2d42qdiJVTwevLYpfRUN1Uk=
Message-ID: <a8e1da0708062356g7f6f23c3pb17c4324ec71e515@mail.gmail.com>
Date: Tue, 7 Aug 2007 06:56:02 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: unable to handle kernel NULL pointer dereference in qla2x00_read_nvram_data
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1186457339.4688.213.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186456912.4688.209.camel@ymzhang>
	 <1186457339.4688.213.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/7/07, Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> On Tue, 2007-08-07 at 11:21 +0800, Zhang, Yanmin wrote:
> > Did someone see the same issue? My machine has a qla fiber card.
> >
> > This error is triggered because parameter buf of qla2x00_read_nvram_data
> > is 0.
> Sorry for missing kernel info. I used kernel 2.6.23-rc2. My machine is
> a x86_64, but I installed i386 os on it.
>
> If I disable CONFIG_SCSI_QLOGIC_1280 and CONFIG_SCSI_QLA_FC in kernel config,
> kernel could boot.
Hi,
what version of kernel do you use?
I read the code, maybe 23-rc1-mm2 fixed the bug.
-mm2 add the code to alloc nvram buffer.

Regards
dave
