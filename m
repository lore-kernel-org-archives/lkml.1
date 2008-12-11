Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYLKIFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYLKIFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYLKIFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:05:36 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:44134 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbYLKIFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=nyJWRpVT1gScUMTeKqg4JTezhS8Bh1PZmllp8FJgRxmoVdZD7Nc+7ovO4r36hpdAkY
         k9GV3b630pr5vQwDRNgWAdNHR+j7iYyikCPZ6lg1YhuG/rZG7E+4Mk5vks/FmJat7IC5
         opBOu4P04cweWM9RCRdcAI6VeFj21InLJoV1Y=
Message-ID: <14cd75110812110005n2809dae7n909a606f68ff1a61@mail.gmail.com>
Date: Thu, 11 Dec 2008 13:05:34 +0500
From: "Muhammad Mutahir Latif" <mutahirlatif@gmail.com>
Reply-To: mutahirlatif@gmail.com
To: linux-kernel@vger.kernel.org
Subject: SATA passthrough commands from User Space
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am new to linux kernel development and need help in developing an
application in linux for a SATA device. What is required is that the
application needs to send raw SATA commands along with data (like Read
DMA, Write FPDMA etc) to a SATA hard disk. Secondly we also have to
achieve a reasonably high data transfer throughput.

As a starting point I was thinking of modifying the AHCI driver by
adding an IOCTL hook to the driver , through which the user space
application would be able to send command and data to the drive. The
IOCTL function in the driver on getting a command would prepare the
appropriate structures, prepare memory buffers and then call other
builtin AHCI functions to perform the operations. Is this the correct
approach for handling such a problem or should we be looking at the
libata and use functions from that module. I would really appreciate
any help from someone who might have modified AHCI or libata so that
raw SATA commands can be sent from the user space

Thanks

Mutahir
