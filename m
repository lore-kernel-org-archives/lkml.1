Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbXJMRKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbXJMRKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXJMRKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:10:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:18189 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbXJMRKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hHnNdRiSlaxzLv9+7I5QXNeB9FCVdHH1Vs75PQgd6kD2v76IVjmcaLRjc1X6t0qJfTEJEjT3zw/F10Cq3Rt/mEmNH4GHRFnQ2tVCz6sECBuY0odLRatpk4OkNaV/NznpP7ICRLv0xrcteL95N8jWeRTXxfQV4ERN3c3mi5BuQ04=
Message-ID: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com>
Date: Sat, 13 Oct 2007 22:40:23 +0530
From: "vignesh babu" <vigneshbabu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: wierd file perms
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Was having trouble with the latest source-in compiling it and did an
mrproper which fixed things...well-temporarily.

I was hitting another issue with permissions-as root :(

I was surprised and did an ls -l on the files and guess what I found:

total 0
?--------- ? ? ? ?                ? fcntl.c
?--------- ? ? ? ?                ? fifo.c
?--------- ? ? ? ?                ? filesystems.c
?--------- ? ? ? ?                ? file_table.c
?--------- ? ? ? ?                ? freevxfs

So end result is that, Im not able to delete the files or change perms
or ownership even as root.

Can some one help please?

How did this even happen?

I could compile without any issues till yesterday and todays update
seems to have caused this...

Not really sure if it is just a local phenomenon....
-- 

----------------------------------------------
"Why is it that every time I'm with you, makes me believe in magic?"
