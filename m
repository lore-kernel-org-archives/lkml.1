Return-Path: <linux-kernel-owner+w=401wt.eu-S936092AbZDCUCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936092AbZDCUCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765116AbZDCUCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:02:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:51334 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbZDCUCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=GDyeSrr4qwyEU8UKQsfKhtodmCszwr+4LM+aPJvVKqyUlkzFnMnzU1yvjdC/95TGhn
         nAr5ukyo9js84q8ZHuILAu0eldVOR4LZlSQWVnPusXcjUzlBQXtwFxew3dBlOiDs/bl5
         1cg8fCAuS3dkMe61L/+1K0rT2Mh98kNRKVnoY=
MIME-Version: 1.0
Date: Fri, 3 Apr 2009 14:02:07 -0600
Message-ID: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>
Subject: Off topic: Numactl "distance" wrong
From: Chris Worley <worleys@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for an off topic, but I'm hoping somebody can point me in the
right direction of where to direct this question...

I have an Opteron system where I've seen the HW diagrams, and each of
4 sockets is directly connected (HT) to two other sockets, and two HT
hops away from a third (i.e. a simple square topology, no X in the
middle).

Yet, "numactl --hardware" shows but one hop to each socket:

# numactl --hardware
...
node   0   1   2   3
  0:  10  20  20  20
  1:  20  10  20  20
  2:  20  20  10  20
  3:  20  20  20  10

I know this is wrong.

Who would be the right person (or list) to talk about this?

I'm using the latest numactl 2.0.3-rc2 source and a 2.6.29.1 kernel.

Thanks,

Chris
