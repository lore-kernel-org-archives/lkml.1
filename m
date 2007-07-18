Return-Path: <linux-kernel-owner+w=401wt.eu-S1763933AbXGRNtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763933AbXGRNtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbXGRNtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:49:09 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:50463 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbXGRNtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ee3RDWYu5oEJsHD8bh69AM2A9ub7X4tlDWYRjwK3DVpLB5RP7899kXBJ0wF+9be5YOLUtQHfE+GZ3jBDD1C6RWL/ZDJcL/5Gqt6dslZACG+hFEFFEQakyrIq1ZFd4rdTEZTU6d5CkVQ4CLw+YpUxMUqmFiEkeHh/ZXogD4KGPAg=
Message-ID: <f44c5fdf0707180649h778f017dlb532c3ba224944b2@mail.gmail.com>
Date: Wed, 18 Jul 2007 15:49:07 +0200
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: XFS -git changes and Linux-VServer patch porting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux-VServer patch adds 2 new flags: barrier and iunlink.
With recent changes in -git (filestreams), XFS now lacks di_flags bits
to add these.
iunlink flag adds Copy-on-Write semantics to hard links, while barrier
flag signifies a filesystem barrier no virtual context can pass.

I'd like to know how to possibly resolve this problem w/o negatively
impacting performance (especially of iunlink) or changing on-disc
format in an incompatible way, as well as being more future-proof.
