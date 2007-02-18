Return-Path: <linux-kernel-owner+w=401wt.eu-S1946447AbXBQIXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946447AbXBQIXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 03:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946489AbXBQIXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 03:23:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:15899 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946447AbXBQIXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 03:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=MBhZjquzX5k8opDqdO+ZZbNTeC9zpL4G6Hek7PQebeNqarUg8PJ+/GVCpPUydrK4uIeY2+54aHsXfG+LfDRy8z1/7rxq5uNmji1mdU5vklJPhyBNIwz6rTWUA+f7ECrwr4zEvVVyqY5B0BZiB/M6SnxxA1EhoU4D9gmZo0ZyI8U=
Date: Sun, 18 Feb 2007 08:22:15 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-mm1 USB-related OOPS
Message-ID: <20070218082215.GE32060@slug>
References: <45D657C2.4040304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D657C2.4040304@gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 06:17:54PM -0700, Berck E. Nash wrote:
> I get the following OOPS on boot, presumably connected with USB driver
> loading.  I've attached the entire log.  Please CC on replies as I'm not
> subscribed.
> 
> Loading kernel module nvidia.
> [  149.135709] nvidia: module license 'NVIDIA' taints kernel.
Hi,

Could you try booting without loading the nvidia module? Oopses related
to it have been reported for 2.6.20-mm1. 
See http://lkml.org/lkml/2007/2/16/428

Regards,
Frederik
