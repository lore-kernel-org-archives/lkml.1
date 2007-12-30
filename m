Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXL3ExL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXL3ExL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 23:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXL3Ew4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 23:52:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:56814 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbXL3Ewz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 23:52:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qYSw8Yk2jKnZsiGEo3UwSK18oV1zvUQeeCRb5eMm6cvVKTJCrTliWAVFTZtxKMTGAwKTZoECX//WjFsZF4c2CAKyP5V0CSv7ndYGhQZYpM7bYhcYX/mkK21QGZn2kVGki92IcqUECWMTm47VluqlvpK/yjBY1PRSXTxwVWhUoFU=
Message-ID: <a276da400712292052h5808c33apd5269e773edfb592@mail.gmail.com>
Date: Sun, 30 Dec 2007 12:52:55 +0800
From: "Xiaofan Chen" <xiaofanc@gmail.com>
To: mgross <640e9920@gmail.com>
Subject: Re: [RFC] USB driver for talking to the Microchip PIC18 boot loader
Cc: "Alan Stern" <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20071230035349.GA4741@mgross-t43>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229193409.GA20188@mgross-t43>
	 <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>
	 <20071230035349.GA4741@mgross-t43>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 11:53 AM, mgross <640e9920@gmail.com> wrote:
> Yeah, it has been done from user space using a libusb based
> application.  (that didn't work with a usb-hub in the loop) and had
> code that was just too nasty for words, so I made a kernel driver that
> looks nicer to me and enables a nice python FW loader program to work.

http://forum.microchip.com/tm.aspx?m=275422&mpage=2
Just a guess why it does not work: this might be due to the auto-suspend.
If you update your kernel, it should be ok. The firmware is also to blame.

> What is the linux-usb policies on new drivers that could be
> implemented in user space?  When does a kernel driver make  sense over
> a libusb one?
>

That would be interesting to know.

Xiaofan
