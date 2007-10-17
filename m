Return-Path: <linux-kernel-owner+w=401wt.eu-S935434AbXJQUtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935434AbXJQUtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933626AbXJQUtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:49:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:10446 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631AbXJQUtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=hkJ4wUuyI/GQny6TKovKZTr9yKu5w5icOXj8EImyaYewFZcwWSApEQrWDbCNid++fX+d/fXb6hV0RtXF26SbzFvcqOvvqkkWHLLNghbOEksTud+YzM7x2s89c025lYJ1T+dsl5GP7U5Uz6LE67iNfnrIom24yI2zi8T6ZikqepA=
Message-ID: <75b66ecd0710171349n2a2a5922qfc0d8bb64980a15c@mail.gmail.com>
Date: Wed, 17 Oct 2007 16:49:07 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: VM question - accounting of SysV SHM
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 3ba63c72060a4a6b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to ask this question on the list but I've Googled and found nothing.

Is system V shared memory accounted for as Cached, or as normal
application memory?

I have an application that uses SysV shared memory and O_DIRECT for
all IO, but when it starts up, the cached column in vmstat seems to go
up by the amount of shared memory allocated.

Lee
