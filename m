Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbXL0PjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbXL0PjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 10:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXL0Pi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 10:38:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:56290 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbXL0Pi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 10:38:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QlBgzNvB7lbT9q0ttA1fKIZhL0TBEjySzYsTuvSSmfC2DJ6wJd6MBCGVD4hVa8662/0RVMSqu8gwK6vD7y6XloUl5Nw03bFoP5VEuw+nKLG7+16zedftzl6PQdIOyCjyp5zCRryqKDkrtfcomO2LIJovG2SsOk6PP1VQa9UuNtg=
Message-ID: <c70ff3ad0712270738v2551224ft5694a5673c37aa3c@mail.gmail.com>
Date: Thu, 27 Dec 2007 17:38:57 +0200
From: "saeed bishara" <saeed.bishara@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: read-ahead in NFS server
Cc: linux-kernel@vger.kernel.org, "NFS list" <linux-nfs@vger.kernel.org>
In-Reply-To: <4773BFBA.70709@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c70ff3ad0712260351i6583aa8dpbf16ed606a634b1f@mail.gmail.com>
	 <47730F2F.3080900@garzik.org>
	 <c70ff3ad0712270050u134616d1q459ed073c586dcec@mail.gmail.com>
	 <47739288.7000308@garzik.org>
	 <c70ff3ad0712270700h6336b194r7c21834423aeb331@mail.gmail.com>
	 <4773BFBA.70709@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I bet
>         TCP + fewer revalidations + greater local pagecache activity
> uses less cpu power than
>         UDP + revalidations + rx/tx network activity
what do you mean by revalidations?
the workload of the client going to be large sequential IO's, so does
the local pagecache is necessary for this case?

saeed
