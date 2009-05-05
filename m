Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZEEPef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZEEPef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZEEPeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:34:23 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:7237 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZEEPeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KwOoANw1n98Faxzcb+wU/K2CWAqaqMDxbA965NCA8QCbPQIBvxRzBvZGQZhKkroeNM
         HdiL/VOieAC0Rn5kNr63YgH+uW7CxArNGBdJnViOOWjFA95eiXjTXE/+/OjzPwR2KM2z
         j6lvTBuLDc/jxlY9UMIo/JLa5RIzmwdY7mMGc=
MIME-Version: 1.0
In-Reply-To: <49FFB275.7000507@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>
	 <49FA0349.3090706@garzik.org>
	 <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
	 <49FEA127.1000905@kernel.org>
	 <e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>
	 <49FFB275.7000507@kernel.org>
Date: Tue, 5 May 2009 08:34:21 -0700
Message-ID: <e9c3a7c20905050834t79a1c03dt83df288b2f38ed76@mail.gmail.com>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
From: Dan Williams <dan.j.williams@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       Mauelshagen@redhat.com, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 8:28 PM, Tejun Heo <tj@kernel.org> wrote:
> Pushing this in the kernel without updating dm-raid is kind of
> pointless.  Who should I be poking to get the userland part moving?

Dmraid is not the only potential user.  Mdadm will also care about
this as I have seen a report that points to a user having what looks
like an HPA issue with an Intel(R) Matrix array.  So, there are two
immediate users for this interface.  Heinz is the right person to poke
for dmraid updates.  I'll handle the mdadm update.

Thanks,
Dan
