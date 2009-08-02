Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZHBVZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZHBVZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZHBVZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:25:22 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55363 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbZHBVZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UsDPZSHvv4e15afEZGIZP0VAZqXwpuPvMRZEFz2ys2lVMH9PBEE+fb1qgNveyACo8c
         6wukY1pKB+I+Qsm0iElY/yBLcbgHFH9bwErqSn6smfyjJUER5bpa9IRYuthgWb4gIKik
         3E98JXJSP72577vJFTcFI6jMZAla51AV0wW50=
MIME-Version: 1.0
In-Reply-To: <200908022322.36343.oliver@neukum.org>
References: <81b0412b0908021339s739c07edvd4d5eb4c21cfa167@mail.gmail.com>
	 <Pine.LNX.4.44L0.0908021650020.14120-100000@netrider.rowland.org>
	 <81b0412b0908021409h73fc2fcfo64c4ba9ee1f0d552@mail.gmail.com>
	 <200908022322.36343.oliver@neukum.org>
Date: Sun, 2 Aug 2009 23:25:20 +0200
Message-ID: <81b0412b0908021425r33136b7et942822c64dd26a1e@mail.gmail.com>
Subject: Re: Oops in CDC ACM after an Openmoko phone (neo1973) changes its usb 
	interface from ACM to Ethernet
From: Alex Riesen <raa.lkml@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.name>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 23:22, Oliver Neukum<oliver@neukum.org> wrote:
> Am Sonntag, 2. August 2009 23:09:37 schrieb Alex Riesen:
>> So, I connect the device, run its bootloader, which causes
>> a CDC ACM interface to appear. The /dev/ttyACM0 node
>> appears, and I open it (with minicom). Then I just switch
>> the device off and kernel oopses with:
>
> It oopses _before_ you terminate minicom?
>

Yes. minicom was running at the time, and had the ttyACM0 open.
