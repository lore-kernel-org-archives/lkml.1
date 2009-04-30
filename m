Return-Path: <linux-kernel-owner+w=401wt.eu-S1763234AbZD3QCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763234AbZD3QCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZD3QCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:02:38 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:51502 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZD3QCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=qUaE5okiDlyT7lAS/9srdkhHf7VhPP8uHSbzAssDCxrOLEPvfdWiFTjm6fwcpemN47
         bXovUzL67PwvCCSd3GcqI8dlk03raIpFJTSDrH8R4lgX09E425i2RBJNVkiqSPJqSe+W
         hv+c08S6P+6MxdxkT5oY3MYvf5Ez383QJGvyk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len
Date: Thu, 30 Apr 2009 18:07:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com,
       Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com,
       Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, paul.clements@steeleye.com,
       jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       bharrosh@panasas.com
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904301807.10302.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009 11:13:38 Tejun Heo wrote:

[...]

> As the patchset contains several block-ide sync points, I think it's
> best to apply this series in unified series.  SCSI also received good
> amount of changes.  If there's a tree I can pull from which won't be
> rebased, please let me know.  If SCSI tree is gonna pull block tree
> after merge, that will be fine too.
> 
> All changed llds have been compile tested, mid-high layer resid_len
> handling has been verified and nothing broke during my test runs with
> ide and libata.

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

on drivers/ide parts and block ones (FWIW)
