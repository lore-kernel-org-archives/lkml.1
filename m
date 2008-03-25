Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYCYIQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYCYIQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYCYIPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:15:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:32100 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYCYIPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=uF2Tub8qUozVcxGAr0kQocrhjfokdDh9Q5IIeFZDiiXmuE2A+ZWrNWIC9joJv8+jO9ZGabVSCvbjJ0v+Mt5DUIKCGWjYQyMW/v9V0MLJPK+7MW+DLbkTs/mkftk/sn1XQypCWVsQAZaR1WHdmcOsnqlebHpVKFNSAVL5sNV0B3k=
Message-ID: <e2e108260803250115j4047b242t85c4d719501482bf@mail.gmail.com>
Date: Tue, 25 Mar 2008 09:15:47 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Kernel compilation: make halts with error message "*** target pattern contains no `%'"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I try to compile the latest git tree
(git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git,
last change	Tue, 25 Mar 2008 06:24:16 +0000), make halts and prints an
error message. This happens both with GNU make version 3.79.1 and
version 3.81. The 2.6.24.3 kernel builds fine on my system with the
same tools, and that the Documentation/Changes document has not been
changed since 2.6.24.3. Does anyone know how I can get around this ?

# gmake --version
GNU Make version 3.79.1, by Richard Stallman and Roland McGrath.
...
# gmake
Makefile:112: *** target pattern contains no `%'.  Stop.
# make --version
GNU Make 3.81
...
# make
Makefile:112: *** target pattern contains no `%'.  Stop.

Bart.
