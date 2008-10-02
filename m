Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYJBPEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYJBPEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbYJBPD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:03:57 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36759 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbYJBPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qyOYbC854KE1kGGPE2tVIktqzsMHL94y9ULx+ICBx/T7OMiXEOKe6aMMcXlkUQT5bz
         vlp7ALqvGlGU84q6b40Io69SNrCx32tKsIEQ3Ncb8zeRUznHLAuRM8mnd3y1AWDXmApL
         Lmh2WEbZM7QCFTnMDpPbO4E9Y95xPNEk2ax/s=
Message-ID: <3c1bc2140810020803l33207ecbsbd690fa33a21a360@mail.gmail.com>
Date: Thu, 2 Oct 2008 10:03:55 -0500
From: "Matthew Stoltenberg" <d3matt@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: motherboard recommendations?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081002143809.GA22851@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1f276abf0809160657x4264ad5dm74fd2689d804a7ad@mail.gmail.com>
	 <20081002143809.GA22851@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Now I think about Intel chipset - P35 or P45.
>> I want Asus, Gigabyte or MSI board with heat pipe.
>> But I found another issue with audio and network drivers for Asus
>> boards, so maybe I will skip Asus this time?
>>
>> Which motherboard works stable for you?
I got an ASUS P5Q (P45 chipset) a couple of weeks ago.  A couple of
minor issues:
* The Marvell IDE controller is broken in 2.6.25 and 2.6.26.
* Make sure the sata controller is running in AHCI mode
* The onboard Atheros NIC is not supported in the kernel.  I have to
build the driver seperately (it's actually on the driver disk)

The intel HD audio works great.
