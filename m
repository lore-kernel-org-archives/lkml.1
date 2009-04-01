Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbZDAO7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbZDAO7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758525AbZDAO6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:58:55 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:49003 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbZDAO6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:58:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=OMBfbkChHefYyixAqdG2tNgCQ/ohPzMk69Z+FzD9DmhnVSJZzJNHyfKyFkGR6DBhuS
         ltqkk10GeJFY9SPofRWwgx4KP1iW7qCE8FTOLjr7V3dGU/gp/r+WxdoBOUEB5fKxioZz
         NzwRmuZnTmnaZOdrT8Igm2apu7oYPw2EzZ+dM=
MIME-Version: 1.0
Date: Wed, 1 Apr 2009 23:58:51 +0900
Message-ID: <a6b9f31a0904010758r23767adco16ea4ee45d7e158e@mail.gmail.com>
Subject: [RFC] Improving scheduler for asymmetric multi-core processor in 
	Google's summer of code
From: Hitoshi Mitake <h.mitake@gmail.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found an interesting problem, scheduling on Asymmetric multi-core processor.

According to this paper,

http://portal.acm.org/citation.cfm?id=1362694&dl=GUIDE&coll=GUIDE&CFID=28487975&CFTOKEN=68150071

taking performance asymmetry into consideration on multi-core CPUs can
improve scheduler performance.
(And I think discarding this could have bad consequences.)

So I have a question:
Is the current scheduler of Linux aware of possible performance
asymmetry of the cores?
By performance asymmetry I mean a case where different cores run on
different frequencies.

If something tackling this issue is not implemented yet,
I would like to work on that as a project of Google's summer of code.

Thanks
