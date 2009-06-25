Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZFYSgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZFYSgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZFYSga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:36:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:52678 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZFYSga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=jWmjMjedNKOMLJNjomUA/55HQSfErFtN2QGX20D3PLrhDgKFsbDOKB43PK8b2TX8Ls
         6rgXp7H9bywj15NNkOvzsHW4B62vKCReICunxfnCHba0SNmJ8Gl3wkPhXlRKMu+w7pQd
         rOs8555FbuZtk72ZaWeVNvkUJUj26afy44LXM=
MIME-Version: 1.0
Date: Fri, 26 Jun 2009 00:06:32 +0530
Message-ID: <abe8a1fd0906251136t36d78428k90a610fdff987ab6@mail.gmail.com>
Subject: Slowing down the schedular, How?
From: kernel mailz <kernelmailz@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a SMP linux running on 85xx poweprc. Say on Core 0 and Core 1
two different processes are running and on both the schedular runs.
Now for some special case, if one of my process issues a ioctl which
gets serviced by a kernel module, I wish to slow the schedular on that
core only. Otherwise the performance will get degraded.

Should I use highest priority tasklet, will it be sufficient or i need
to do something special

-TZ
