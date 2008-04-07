Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbYDGPoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbYDGPoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYDGPoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:44:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:1460 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYDGPoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:44:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RLJnpQOMUtRPk8Vtk4h8aAtM/mKEM8UC05AIYjARsIfFzxESxUNLaNaXtZ9Ocp2xv4VKK6uLykNBdK90p5c8YNOgUQ1tDFISFMucJxHCZ8ExTkq7afT86QQ5xhbDG17hHUVT3+RBC/aODKPb3Mn9cFGxVEj9NUYdn8K0XxsiMug=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: Trouble compiling kvm.git
Date: Mon, 7 Apr 2008 21:07:38 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Ke Wei <kewei@marvell.com>, linux-kernel@vger.kernel.org
References: <200804072037.08069.balajirrao@gmail.com> <1207581636.3838.9.camel@localhost.localdomain>
In-Reply-To: <1207581636.3838.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804072107.38113.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2008 08:50:36 pm James Bottomley wrote:
> On Mon, 2008-04-07 at 20:37 +0530, Balaji Rao wrote:
> > Hi,
> > 
> > I had trouble compiling kvm.git.
> > 
> >   LD      drivers/scsi/built-in.o
> > drivers/scsi/mvsas.o: In function `sas_ata_init_host_and_port':
> > /kernels/git/kvm/include/scsi/sas_ata.h:50: multiple definition of `sas_ata_init_host_and_port'
> > drivers/scsi/libsas/built-in.o:/kernels/git/kvm/include/scsi/sas_ata.h:50: first defined here
> > drivers/scsi/mvsas.o: In function `sas_ata_task_abort':
> > /kernels/git/kvm/include/scsi/sas_ata.h:54: multiple definition of `sas_ata_task_abort'
> > drivers/scsi/libsas/built-in.o:/kernels/git/kvm/include/scsi/sas_ata.h:54: first defined here
> > make[2]: *** [drivers/scsi/built-in.o] Error 1
> > make[1]: *** [drivers/scsi] Error 2
> > make: *** [drivers] Error 2
> 
> Actually, the problem is a long standing one.  The fix is in scsi-misc:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=6bd758961524129d2ad0163001681ebc2c7809e4
> 
> The work around is to compile SCSI as a module or not include mvsas.
> 
OK, thanks. But surprisingly i discovered it only today, after I updated my kvm.git tree. :)

-- 
thanks and regards,
Balaji Rao
Dept. of Mechanical Engineering,
National Institute of Technology Karnataka, India
