Return-Path: <linux-kernel-owner+w=401wt.eu-S933567AbZKYRrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbZKYRrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbZKYRrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:47:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:34390 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922AbZKYRq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:46:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=RW3sY7dnimY2tzDFkBIZp8JiFA05+bAWszI64+EOZBAJsmFfvOel2DHh4eZiELS5hH
         rjLtTMJxxGoXuRbZwhYkQtytNlTtOTNKq67lqZ5fF8xpG2FlYl/zD2XZoCELmQ7jZLd6
         40zLqI6/wrxQAyaoBV081t2XSdTtVtH9vmP5U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 19/86] pata_cmd640: document known issues
Date: Wed, 25 Nov 2009 18:44:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125172633.7a15711b@lxorguk.ukuu.org.uk> <4B0D6B4F.9030605@garzik.org>
In-Reply-To: <4B0D6B4F.9030605@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251844.01227.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:37:19 pm Jeff Garzik wrote:
> On 11/25/2009 12:26 PM, Alan Cox wrote:
> > On Wed, 25 Nov 2009 18:04:36 +0100
> > Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>  wrote:
> >
> >> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> >> Subject: [PATCH] pata_cmd640: document known issues
> >>
> >> Document known issues with the driver to aid distribution makers,
> >> users and developers in making informed decisions instead of wasting
> >> their time needlessly.
> >
> > Umm. its a) under CONFIG_PCI, and b) says CMD640 PCI IDE...
> 
> Agreed, that's a bit redundant.
> 
> Also, as I noted in another email, known issues should be listed in the 
> driver source code at the top of the file, not in Kconfig.

Agreed, since virtually everybody should be looking into source
code of each single driver before compiling kernel and/or deciding
to include it into distribution kernel.

--
Bartlomiej Zolnierkiewicz
