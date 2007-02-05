Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbXBEDEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbXBEDEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 22:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXBEDEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 22:04:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:30951 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbXBEDEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 22:04:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N7RgsqWg026kZXTlNoU+6YZYnP7GU8seaCmHVioqv8t1SZlZBF+xw0EWWhrnWJvPp5LyAq7/rCsqBA3Snhbwd0fMqakl5ed9BsyX3CDpwZm8ZPT/y3rNKWxZnnzfyittSbsgr8d+Vf3VGYsat9fsFX4a7lkaRB1hzv+Dsa5PyOo=
Message-ID: <3877989d0702041904w1b57bb1dufbb731d2823d0b64@mail.gmail.com>
Date: Mon, 5 Feb 2007 11:04:52 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> Hi,
>
> I get this error on booting up 2.6.20 (Similar error on 2.6.17.7 also,
> the message is slightly different in 2.6.17.7)
>
> PCI Cannot allocate resource region 2 of device 0000:02:0a.0
Just did a search about this message around the kernel source tree.
The interesting thing is that I see the following comments at several
different arch/drivers files. Is it related to your problem?

 *  Known BIOS problems we have to work around:
 *      - I/O or memory regions not configured
 *      - regions configured, but not enabled in the command register
 *      - bogus I/O addresses above 64K used
  *      - expansion ROMs left enabled (this may sound harmless, but given
  *        the fact the PCI specs explicitly allow address decoders to be
  *        shared between expansion ROMs and other resource regions, it's
 *        at least dangerous)
