Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbXDKSnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbXDKSnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbXDKSnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:43:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:63408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbXDKSnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:43:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:
	x-accept-language:mime-version:to:cc:subject:references:in-reply-to:
	content-type:content-transfer-encoding;
	b=lCicJ8NblbYJEqEZxJC9tyYec1IJidlFc7EABhwHXyEIOJeXQbdx7Dg2lb6uADYyb
	m58KiB/8NK3TfkKoFXm9g==
Message-ID: <461D2C46.5040603@google.com>
Date: Wed, 11 Apr 2007 11:43:18 -0700
From: Edward Falk <efalk@google.com>
User-Agent: Mozilla Thunderbird 1.0 (X11/20050207)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Uytterhoeven, Geert" <Geert.Uytterhoeven@eu.sony.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: HDIO_* ioctls
References: <CA6404BA52C51146981195CF9A147C1C01A99FC6@GBISE0BASMSX01.eu.sony.com>
In-Reply-To: <CA6404BA52C51146981195CF9A147C1C01A99FC6@GBISE0BASMSX01.eu.sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uytterhoeven, Geert wrote:
> 	Hi,
> 
> Documentation/ioctl/hdio.txt says:
> | This document attempts to describe the ioctl(2) calls supported by
> | the HD/IDE layer.  These are by-and-large implemented (as of Linux 2.6)
> | in drivers/ide/ide.c and drivers/block/scsi_ioctl.c
> 
> However, drivers/block/scsi_ioctl.c does not exist.

It's likely that files have been moved and/or renamed since I wrote that 
document.

> drivers/scsi/scsi_ioctl.c and block/scsi_ioctl.c do exist, but they don't seem to cover any of the
> HDIO_* ioctls.
> 
> Does SCSI cover any of these ioctls at all?

Look in the libata layer.  I know that some of the ioctls are not 
implemented yet, or are incomplete.

	-ed falk
