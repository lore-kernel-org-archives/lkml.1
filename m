Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbXBNBmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbXBNBmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932217AbXBNBmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:42:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:35889 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbXBNBmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:42:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bRMWryuujju3+ttGaH39ZR28XODOjvnpZ3Z7QjjCCLtxUPdpfdcNW1UF31x6VZAEi66ilK52yeXncxpsf2AGVHkjtntiqVYnrRBhh0vz8wm6kLLvloDhdiGXYerJYaHl7ldDpdzrzekkHZXyRHiXDRSCe2ixFQKIzolhLu3r8iY=
Message-ID: <1ace22690702131742u18aec57egbfe465d179014b08@mail.gmail.com>
Date: Wed, 14 Feb 2007 12:42:01 +1100
From: "Alex Shinkin" <alexshinkin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Serial driver doesn't handle FIFO error ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all .

I am working on serial communication protocol for an x86 industrial platform ,
namely Advantech PCM 5825 CPU board + PCM 3618 RS232/485  communication board.
Tried 2.4.33 and 2.6.18...20 kernels .

After investigating some incoming data corruption I noticed that
sometimes the status value that has been read from LSR  contains the
"FIFO error" bit set ( 0x80 ) . I did not find a code that handle this
condition , there is no even such bit mask defined in serial_reg.h .
BTW I have this bit set even if all other error bits in LSR are 0  (
frame error etc.) .
Is there any reason for not to handle the "FIFO error " bit ?
Or it is just because the situation is very rare ?

Any comments appreciated .
Thanks .
