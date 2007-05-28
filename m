Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbXE1W7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbXE1W7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbXE1W7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:59:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:62254 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbXE1W7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FgjTK8z1zH1D9X7mehYsq8jTjG0zos9aadlNxiNMCphY+Tnbpl8HZC7HaePJurThJhdau4tlI/BYJadeF/s6C/9ME5W8ha05u5N27lor0bCVEfKm4Mwy+aYEbus6df4RNRV+/vYbwJNggC9f6LTlqmQ3H6vy+Z+AN1Xgqvook4k=
Message-ID: <3d57814d0705281559y56576567r2c23edda5f22c3cf@mail.gmail.com>
Date: Tue, 29 May 2007 08:59:37 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Portable syscall inspection
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Someone finally noticed that my program that uses ptrace only works on i386..
and, by the looks of it, there is no portable way to refer to the
registers of a
user_regs_struct when inspecting a system call.

I will probably end up making a header file for each architecture that
defines where
in the user_regs_struct things like the syscall number, the return
value and the first 3 parameters are..

has anyone done this already?  or can otherwise save me a lot of time?

Thanks,

Trent
