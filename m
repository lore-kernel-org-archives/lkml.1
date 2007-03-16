Return-Path: <linux-kernel-owner+w=401wt.eu-S965415AbXCPQNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415AbXCPQNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXCPQNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:13:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:39593 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965415AbXCPQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IiZEZne5NawQVc7Fmyv5yagOWqs5WaZ1tNJRPiX1UDEfcnHAgkDLP6xGJYVyEoNTSh+P7ktNSjoybHUeY0k3kP8hTAUt026CW9EUPojiXOuUKICHWPuU0cqu7NoQdHqURYfK0Et/PbIIruP6o1pkjRM7zeBbsAh/VoxezNG0Bm0=
Message-ID: <25db37b80703160913y1d30f16dw5d5e8f37ff03a8d4@mail.gmail.com>
Date: Fri, 16 Mar 2007 17:13:08 +0100
From: "Guerreiro da Luz" <g.da.luz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: decrease L2 cache size used by Linux?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am benchmarking dumb matrix multiplication in trying to perceive
performance drop in case when matrix cannot fit in L2 cache.  However,
on my machine L2 cache is large - 2MB, so 512x512 matrix of double
numbers is needed to fill the cache, and in that case multiplication
is taking rather long time.  So I'm wondering is there a way to
control (decrease) L2 cache size used by Linux?  Apologies if question
inappropriate for the list.

Thanks.
