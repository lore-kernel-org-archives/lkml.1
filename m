Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZDNOLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZDNOLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZDNOKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:10:55 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:44921 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZDNOKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PNaI6EIDRYhTYtb+ZdmBuB5NMRtETVlMOAjQS6b2sn21OJOJlrlTG9a8DbqqZgTQhM
         y55uFRhyWDkYCXdz8IxaYwv1CexeoMqckf1HtLxbkmmPv3hkr1G/GRBIcnAjyR0fFyEQ
         DUwTqS6T2GWF+dDbAUsvD+m0AXXQncF743mlU=
MIME-Version: 1.0
In-Reply-To: <9b2b86520904140636x1971b44g898c29e8b0904396@mail.gmail.com>
References: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com>
	 <9b2b86520904140636x1971b44g898c29e8b0904396@mail.gmail.com>
Date: Tue, 14 Apr 2009 16:10:52 +0200
Message-ID: <2d05c4580904140710p6638ad91k706149c2c7d5686@mail.gmail.com>
Subject: Re: Fast testing
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: alan-jenkins@tuffmail.co.uk
Cc: andi@firstfloor.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm,

Ok, I found this on internet:
"The bzImage file is in a specific format: It contains concatenated
bootsect.o + setup.o + misc.o + piggy.o.
  piggy.o contains the gzipped vmlinux file in its data section (ELF)
(see compressed/Makefile piggy.o)."

So after we make new bzImage and "somehow" extract these four .o files
than we can manually load
kernel image into memory ? We can just run same routines that are run
during the boot, but we can skip
everything till piggy.o file, because the vmlinux file is in piggy.o ?

thanks,

Dragoslav Zaric

[Programmer, M.Sc Astrophysics]
