Return-Path: <linux-kernel-owner+w=401wt.eu-S1946401AbXBCIlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946401AbXBCIlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 03:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946402AbXBCIlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 03:41:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:60466 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946401AbXBCIlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 03:41:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EcDiIwqmYvc/uYXrifxo6vTNaYPW8IEEFkjmZCMOQ2vZC+Pn4rThnN2gFeMhqB6JyFBwwUSLm+kU5aryrCUYPQMu0ZvYskqH5D0yq4Hw8ADVnTXu0fRtvqdy16LXiGG3e+af6/VkAoyUiICtHQB6o9AOuW7d7CJzu8AJ2VwwoUE=
Message-ID: <8d158e1f0702030041xaa34440r125a39a85d498f4c@mail.gmail.com>
Date: Sat, 3 Feb 2007 09:41:12 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: hdparm for lib_pata
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Me again, sorry.

Is it possible to make hdparm work with libata?
I have some drives that for some reason fall back to lower UDMA
settings (like UDMA/44) while the drive is UDMA/100. I blame the way I
set-up my raid arrays for this and the bus not being able to handle
all the data that goes trough it but that isnt really the case now.

Anyway, I used to be able to force the drive back with using hdparm
-X68 -d 1 /dev/sdk
But with the new lib_pata drivers I get "Inappropriate iotcl for
device" and HD_IO_DRIVE_CMD Input/Output errors.

Or! Is there some other way to force the drive not to failback to
lower UDMA settings? (Yep, I know, if this is answer, it's my risk, I
cant and wont blame you for destructing my pr0n or severe trauma I
suffer from losing data)


Patrick
