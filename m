Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZKNQBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZKNQBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 11:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZKNQBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 11:01:06 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35278 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZKNQBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 11:01:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CV0th7Fau6EDRRMh7vRtqBf8za13NYTaJ/nRVSzm8FH9ccho/oOo84CWh0fhy9z6wG
         w7cDawBpHrnVhe1Vi2xDgIZjTpy2/sDCOJGvkFOKl/lMwzt9hlRp0neUulYo1Iga9LMQ
         nrk7BQSVJBq+bn6Z0vBtsepVdssl2bvYYXQcw=
Message-ID: <4AFED444.5020201@gmail.com>
Date: Sat, 14 Nov 2009 10:01:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: prepare for removal of experimental tag on PATA
 drivers
References: <200911141537.19068.bzolnier@gmail.com>
In-Reply-To: <200911141537.19068.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2009 08:37 AM, Bartlomiej Zolnierkiewicz wrote:
> Push experimental tags to host drivers that still need it so we can
> remove the "global" experimental tag for PATA drivers.
>
> I hear that some issues are being worked on but the patch reflects
> the current situation and we can trivially update status of affected
> host drivers after new fixes are merged.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>

I don't think that the problems you've mentioned fit the definition of 
the EXPERIMENTAL tag - it means that the driver isn't likely suitable 
for general use. Given that those drivers are probably used by 
significant numbers of people successfully in various distributions I 
don't think this is likely to be the case. There may be bugs but 
non-experimental does not imply bug free.
