Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbZETOzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbZETOzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZETOz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:55:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:62296 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZETOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wB5IoGvTYbeaia6hajK8UHkPIIVjfWIP+NwYGulhEZypRbXHx9HvFRcQLyfXk23yM4
         Fq5bMP6eBAGOZv0ymZu7Wd4/eyUudVGAD354MZ7oE08WcCoxEDnNyl41po4tyTBsTEhc
         u9DFDupxZL4dvirRORSqPx2MYWBIa0TJjwoU0=
MIME-Version: 1.0
Date: Wed, 20 May 2009 15:55:28 +0100
Message-ID: <ff5483020905200755h107d40c3ofbd185693c3535f7@mail.gmail.com>
Subject: FIFO: problems after changing size
From: Jacques Dirac <jacquesdirac@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the kernel source (/include/linux/pipe_fs_i.h) I have adjusted the
size of the FIFOs (named pipes):

#define PIPE_SIZE 8192

This used to be PAGE_SIZE (=4096bytes?).

Now when I read from the pipe (using the read function in a C program)
and the pipe contains more than 4096 bytes, my process crashes and
gives a Segmentation Fault.

Could someone help me on this?


Thanks in advance!

Jacques Dirac.
