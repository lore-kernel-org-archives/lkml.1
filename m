Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZJTT2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZJTT2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZJTT2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:28:07 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:65462 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZJTT2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=EM9Ym96Wax3lM+EOMWvUM+esfQYDRsDoRjJJsjOpS14pnrTLtO1tlUbBIvrKNp9snN
         GOnBo83KUpADaTUYQn6VvhC43cyFsJzBfZ0HRGEN20/qJIZM9W12qqQg/U3CreiR9jVR
         fdC4JeLThZct6Qpz3Y/QBBpKeHj23t/cBdDYo=
MIME-Version: 1.0
Reply-To: davehart_gmail_exchange_tee@davehart.net
In-Reply-To: <m3iqe9kj18.fsf@lugabout.jhcloos.org>
References: <m3iqe9kj18.fsf@lugabout.jhcloos.org>
From: Dave Hart <davehart@gmail.com>
Date: Tue, 20 Oct 2009 19:27:48 +0000
Message-ID: <85d954180910201227q528ff210v575df8c1f83e9ada@mail.gmail.com>
Subject: Re: [ntp:hackers] ntp-dev-4.2.5p235-RC build failure: MOD_NANO not 
	#defined
To: James Cloos <cloos@jhcloos.com>
Cc: hackers@lists.ntp.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see:

https://support.ntp.org/bugs/show_bug.cgi?id=1219

which points the finger at the Linux header and has a reference to:

https://bugzilla.redhat.com/show_bug.cgi?id=505566

titled: timex.h: #define MOD_NANO ADJ_NANO missing

Cheers,
Dave Hart
