Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbXIBUHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbXIBUHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbXIBUHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:07:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:16675 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbXIBUG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RROsE2hmzZ3PewiqJ4mhxhf9xKhCER7/Gs6GQ2KQcQW7QYaFVUCED79uoWs5aRG7jyWtKSBsBnKzbfpFiDVpaWdtDBRWQEBoU2ZSxG+bMlSQ8UvdCMos+hoRcIuXsHfzYW4AtR+3icln+MKJVbqqrkG+aSww/cQsUS0d7jLK32M=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Satyam Sharma <satyam@infradead.org>
Subject: Re: [PATCH -mm] IPS SCSI driver: Check return of scsi_add_host()
Date: Sun, 2 Sep 2007 22:03:39 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <james.bottomley@steeleye.com>, aacraid@adaptec.com,
       linux-scsi@vger.kernel.org
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709022203.39922.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2007 22:13:49 Satyam Sharma wrote:
> 
> drivers/scsi/ips.c: In function ‘ips_register_scsi’:
> drivers/scsi/ips.c:6869:
> warning: ignoring return value of ‘scsi_add_host’, declared with attribute warn_unused_result
> 
> scsi_add_host() is __must_check, so let's check it's return and cleanup
> appropriately on errors.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> 
[snip]

Something seems to be wrong either at your end or mine
> +		IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to add SCSI host¥n");

This should end with a newline  "\n"  but I'm seeing "¥n" ...


/Jesper

