Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZCMECV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZCMECV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZCMECI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:02:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:15923 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZCMECH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mT41GJVCeutWRRDxnEeYcM3E2oF/jDuM3DdmED9Hh51ws97FeLMr4S74+jj58IBi/6
         CTA7xjROmr+/8b4ZMpo/72jQ/Zd6h+Uajcb4Ip+AJdowI5d1YrnxXOK7sbbmFvckYzKp
         QmyapINZpLcMJPh1LV6CCMmCDUSO1jMTXd+/8=
MIME-Version: 1.0
Date: Fri, 13 Mar 2009 12:02:04 +0800
Message-ID: <804dabb00903122102s3d91dff9jd36958a5c7bf0843@mail.gmail.com>
Subject: GPU scheduling
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly I am a newbie in this area of GPU.   Does it make sense to
talk about scheduling tasks on the GPU?   Not the graphics processing
types of tasks, nor the parallel matrix calculation types, but those
normally executed by CPU, so as to share workload along with the CPU?

I supposed the machine codes will be different, right?   But if the
compiler can generate the opcodes for the GPU, and the GPU and CPU can
detect concurrent use of memory bus address (for the implementation of
spinlock - CPU/GPU synchronization), which is synonymous to GPU and
CPU accessing the same memory for data/instructions, then I don't see
there is any problem with the "GPU scheduler" implementation concept,
right?   Or perhaps the hardware does not meet all these requirements?
  Or any other problems which u can forsee?   (eg, GPU being
prorietary, the opcodes may not be revealed/available, and therefore
the internal schedulers is not known to us as well?)

Just an idea.   But searching for "GPU scheduling" on Google does
reveal a number of articles - but targetted at the Windows platform.
 One particular looks similar to the present idea:
http://portal.acm.org/citation.cfm?id=1444484, but I have no access to
read it.





-- 
Regards,
Peter Teoh
