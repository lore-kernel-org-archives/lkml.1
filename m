Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbYDVAnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbYDVAnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760018AbYDVAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:42:55 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:4661 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760004AbYDVAmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ntXo2XNmmilJuLdopZGN4cXz5znjzzao3cmvlVcASyw/srwvm/zTNk6Lb6Pdt2c4ZZcn3buSS9jBu/WL9Nl6JsYogtvxLXLylWDIyfYOvfi8NrsIhUMI3P0brGnPFtpgxtIy+4YPrpeUXBkU4q+nQj09iX4dZOmqgEi7fMzJY/U=
Message-ID: <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com>
Date: Mon, 21 Apr 2008 17:42:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mark Salyzyn" <Mark_Salyzyn@adaptec.com>
Subject: Re: aacraid broken in git
Cc: "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
	 <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bisected to:

yhlu@mpk12-office-77-185:~/xx/xx/kernel/linux-2.6> git-bisect good
e6990c6448ca9359b6d4ad027c0a6efbf4379e64 is first bad commit
commit e6990c6448ca9359b6d4ad027c0a6efbf4379e64
Author: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Date:   Mon Apr 14 14:20:16 2008 -0400

    [SCSI] aacraid: Fix down_interruptible() to check the return value

    Instead of ignoring the return value in aac_fib_send() return 2 to
    indicate to the layers above that fib transmission was aborted due to
    timeout.

    Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:040000 040000 2f23bf33d76d6f37c558251003f88537c6e639fe
63d59091ca7ac527b5106540eea06d7b6649862d M      drivers
