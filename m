Return-Path: <linux-kernel-owner+w=401wt.eu-S1751671AbXCKIFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbXCKIFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 04:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXCKIFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 04:05:51 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:27326 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbXCKIFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 04:05:04 -0400
Date: Sun, 11 Mar 2007 02:04:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: libata extension
In-reply-to: <fa.tUT8ZqaAp2RZveBFqwzUhq3UYGI@ifi.uio.no>
To: Vitaliyi <imgrey@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <45F3B829.2010503@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tUT8ZqaAp2RZveBFqwzUhq3UYGI@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaliyi wrote:
> Good Day
> 
> Say i want to implement extended set of ATA commands available to
> userspace for building diagnostic tools.
> I need 0x40 -- read verify and 0x32 -- write long with error handling,
> for example. I was trying ide driver through ioctl's, but seems it
> lack of functionality and full of gotchas. Furthermore it oopses
> sometimes.
> 
> Is it possible to use libata for such purpose or i need to write
> separate IDE driver ?
> By the way, i'm sure it should be done in kernel space since i'm going
> to deal with some hdd manufacturer commands.
> 
> P.S. I was looking through libata and ide sources and documentation
> but still dont have broad picture.

I believe you should be able to do this by sending ATA pass-through SCSI 
commands into the device using SG_IO, without any kernel changes. It's 
really the mechanism that's meant for this..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

