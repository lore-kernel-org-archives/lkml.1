Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536AbZIAFse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbZIAFse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 01:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbZIAFsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 01:48:33 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64347 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZIAFsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 01:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=no1Ei3E+f3fVCXrsJm8Dig/YEETINgA2Ed/8QEKHo8AN+O2udpvQfmbf00WLZOXSXI
         z/89a0oedgYCRLuH1hxte0F0VVLLsu7PPxGvlu4jV/WHv0CNSwUUxgzyBr8N8ur9B6UH
         VojyqmgHdhg5PiiRzPocL4G7uO/XbgIoCkUgs=
MIME-Version: 1.0
Date: Tue, 1 Sep 2009 11:48:33 +0600
Message-ID: <b9df5fa10908312248x6a8946f5jfbe972f3358baad3@mail.gmail.com>
Subject: [Question] x86,APIC: In apicdef.h dfr,svr,...... shouldn't be const?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys, Intel System programmers guide says - dfr, svr, esr - this
registers should be readonly. So shouldn't they use const? Or is it
anything else?

And apicdef.h also contains a style problem, checkpatch warns about
following style:

              u32	spurious_vector	:  8

Check patch wants as:

                         u32	spurious_vector:8

Shouldn't this issues be fixed?

Thanks,
