Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZFTPdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZFTPdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 11:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFTPc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 11:32:59 -0400
Received: from mail-px0-f202.google.com ([209.85.216.202]:52565 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZFTPc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 11:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y4gWjAvLY37d2jZpANdIOZBT35N1AycyE0uJ7DzzIUyx+e7xRztBjgZHz7Q++bcmmI
         dK8OUNbjsaiLfyMt9LRcAwoJtFPGFYWj82XVbjSovNo5D+dk+saaYyIt6vU05EzT9RYo
         whtzNu/nU0wgKE6Ex+O51zopEPpJSUMBAGcgQ=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0906201052090.13441-100000@netrider.rowland.org>
References: <e42309110906200746u441b82acvec4e3e513253af0@mail.gmail.com>
	 <Pine.LNX.4.44L0.0906201052090.13441-100000@netrider.rowland.org>
Date: Sat, 20 Jun 2009 21:03:00 +0530
Message-ID: <e42309110906200833q52b392d3n592712c0f81b6c9c@mail.gmail.com>
Subject: Re: generic_make_request fucntion for scsi_disk
From: Ravish Tayal <ravish.tayal@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry My mistake.
I will take care of it now onwards
regards
Ravish


On Sat, Jun 20, 2009 at 8:26 PM, Alan Stern<stern@rowland.harvard.edu> wrote:
> You should use Reply-To-All so that other people reading the mailing
> list will be able to follow and contribute to the thread.
>
> On Sat, 20 Jun 2009, Ravish Tayal wrote:
>
>> Thanks Alan,
>>
>> I am actually trying to profile the time taken by each layer to complete the
>> disk write opertaion as sys_write to queue_command invokation veries alot.
>
> Of course it varies.  The kernel buffers disk writes, shuffles them
> around, and then carries them out when it wants to.  As James has
> pointed out, your write(2) system calls don't directly cause any I/O to
> take place.
>
> Alan Stern
>
>
>
