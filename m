Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbXF3OIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbXF3OIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbXF3OIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:08:09 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:49640 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbXF3OIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f/PdgJdEi7ES75xWa4pHn/DjABZhENwFjFhXGXleSUMSLKJKxY+wdUDLu8C0nXuVVhdfPaY2NnquZncxQ8jdy+HVaKidTkpAFnrTKcEVNR9awd7qFxTCOs4ewIX7JLZpxB/ZLsV0ZohdHkji4a+C9AYflIA8p3k8HnQJa2fRcu0=
Message-ID: <961aa3350706300708l3bd4ab31ob9646847ea4f4537@mail.gmail.com>
Date: Sat, 30 Jun 2007 23:08:06 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] void unregister_blkdev - delete redundant messages
Cc: linux-kernel@vger.kernel.org, "Eberhard Moenkeberg" <emoenke@gwdg.de>,
       "Joe Thornber" <dm-devel@redhat.com>
In-Reply-To: <fa686aa40706292314g3323c98dxdecd8b5a289f1c64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070630031013.GC4045@APFDCB5C> <20070630031212.GD4045@APFDCB5C>
	 <fa686aa40706292314g3323c98dxdecd8b5a289f1c64@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/30, Grant Likely <grant.likely@secretlab.ca>:
> On 6/29/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > No need to warn unregister_blkdev() failure by the callers.
> > (The previous patch makes unregister_blkdev() print error message in
> > error case)
>
> Seeing as none of the callers check the error code; why does the
> function return anything at all?

Right. This series of patches is trying to make it return void.

http://lkml.org/lkml/2007/6/29/320
