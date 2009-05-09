Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZEIPOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZEIPOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZEIPNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:13:54 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37141 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZEIPNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=wcK8GY4LWMl7VQPC0ZQQaZ6/l70GMK29+sBkPerOeKG4wCLfO0NV4DCsBNPa3VQ7qt
         K7qWkKSoLz1UvaZlPcqoOIqpkjlIYNKrHhfJxtpVbvVkoGumz33Sme9Ol2Km61a4mtjp
         tlIr2GxVQ4+r1dOVvVA9hMtwltjOrZaoHh7PI=
Date: Sat, 9 May 2009 17:13:48 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: fix suspend/resume for ATA SEMB devices
Message-ID: <20090509151348.GA25760@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Jeff Garzik <jeff@garzik.org>,
	Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090426143836.GA3643@liondog.tnic> <49F4DFA9.6040805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49F4DFA9.6040805@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 07:26:49AM +0900, Tejun Heo wrote:
> Borislav Petkov wrote:
> > due to a class mismatch in ata_dev_revalidate(). Fix it by adding the
> > ATA_DEV_SEMB device class to the check.
> > 
> > CC: Tejun Heo <htejun@gmail.com>
> > CC: Jeff Garzik <jeff@garzik.org>
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Hi Jeff,

any chance this can make it into 2.6.30?

-- 
Regards/Gruss,
    Boris.
