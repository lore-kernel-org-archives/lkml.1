Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXKLTpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXKLTpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXKLTpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:45:08 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:32471 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbXKLTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:45:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JpIv7Q9q8q/8t8hQugm23nZ6aLu7nCzQ8z8BMaqv0MbTLV6kAPa4jQUAYRAlCRjZjNCt/TtLI8+L6jgQQTkc+blMryslP/+2MdM+w9qC+LEBZR3JBYq8IfFIAbgoy2zSSbgx//akXbxdOJUXCxqQ9c4rv8VvMPti8hbWdkc/d04=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Strage buffer behaviour
Date: Mon, 12 Nov 2007 12:44:53 -0700
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <20071111183334.GA6770@dose.home.local>
In-Reply-To: <20071111183334.GA6770@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121244.54251.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 November 2007 11:33, Tino Keitel wrote:
> The dd command reads 100 MB from each partition two times in a row. It
> looks like sda1 and sda2 are not bufferd (the first 4 dd runs), but
> sda3 and sda4 are (the last 4 dd runs).
>
> The computer is a Mac mini with a 2,5" SATA hard disk. The first 2
> partitions contain EFI and MacOS X, and are unused in Linux. The last 2
> partitions are an ext3 partition for / and an LVM for the rest of the
> sytem.
>
> Any hints how the dd/buffering behaviour could be explained? The system
> was mostly idle, and the numbers are reproducible across reboots.

IIRC only mounted partitions' reads are cached.
--
vda
