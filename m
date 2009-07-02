Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZGBFQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZGBFQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZGBFQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:16:17 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:62539 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZGBFQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qbbYyumgZQyuHd/1vir+IuUP12zcUith03s21NJ6L5diC72+SGwHWP/nnL7xiVW+GK
         k0p/+0KAc7GN06DapyVUH4ZqOUF03eYHmAFWLbl7s+ng8yla5lZTUqT98ddluKh5UFKC
         /TbIXwAFZtf+6PgFgw0jOqbhkWzJft49XcqDg=
Message-ID: <4A4C42E2.6030305@gmail.com>
Date: Wed, 01 Jul 2009 23:17:22 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Christof Warlich <christof@warlich.name>
CC: linux-kernel@vger.kernel.org
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name>
In-Reply-To: <4A49A49C.10104@warlich.name>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 11:37 PM, Christof Warlich wrote:
> No, really nothing else but these EXT3-fs error messages are printed to
> vt1,
> and as the disk is not accessible, nothing can be found in
> /var/log/kern.log either.
>
> With respect to libata and SCSI and on a normal system boot,
> /var/log/kern.log just
> contains:
>
> SCSI subsystem initialized
> libata version 3.00 loaded.
>
> so nothing helpful either. Do you want me to send an entire boot -
> suspend cycle
> from /var/log/kern.log?

There should definitely be some libata messages from the suspend/resume 
process, they might not end up in that file though. You might want to 
try changing the console loglevel before suspend so that all kernel 
messages get displayed..

>
> Robert Hancock schrieb:
>> Hmm.. How about any normal output from the libata, scsi, etc? Seems
>> odd you wouldn't get anything unusual there if the file system was
>> complaining..
>

