Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbYBYHFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbYBYHFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYBYHF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:05:27 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:14972 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYBYHF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:05:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DbSa8Nyu9Swwx6CnUQb+O8GG8qOkLLckcilPz6KdPKFu0h5069csou64KzRLDz8G66YVM4p3ag++jeZvhJdpTeGe8hqZnJJ6cxqO27v9/4RZcbruqHfWkTYlYEPJ5XkV05IMOX9cMLb9BlYwqPY2aZcd0RGeMO/c7nNV8T50n7U=
Message-ID: <86802c440802242305o7cfce4d1h6444aab01304cb21@mail.gmail.com>
Date: Sun, 24 Feb 2008 23:05:21 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.26-git0: IDE oops during boot
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Nish Aravamudan" <nish.aravamudan@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       ananth@in.ibm.com, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <47B57436.5020806@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080206105334.GA3664@elf.ucw.cz>
	 <200802112035.39462.bzolnier@gmail.com>
	 <47B16113.1060807@linux.vnet.ibm.com>
	 <200802140000.10639.bzolnier@gmail.com>
	 <47B40DF2.10009@linux.vnet.ibm.com>
	 <86802c440802140228q5f6a606cyee01c711fd349571@mail.gmail.com>
	 <47B57436.5020806@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 3:15 AM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
>
>
>  Thanks for pointing the patch, I do not have the SES config option enabled,
>  then too i tried your patch, but that does not solve the panic. The kernel
>  panic's with the same panic message as before. I have attached the .config
>  file which i am using, please let me know if i am missing out/getting wrong
>  any option in the configuration.

can you try x86.git#testing?

http://people.redhat.com/mingo/x86.git/README

YH
