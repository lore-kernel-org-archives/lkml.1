Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbYEXPnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbYEXPnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbYEXPl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:10415 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYEXPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=c56ePXb5lMlMvJAjuM9ovYufYIWb8TnE8mttxTpTdZO54c1S8jVYfBFmtPQb9QpDR9AwQxSMDQl+/MB+WFss6kcYZeimUCof/42ch/8OWSGYvj4fz012yMyws6Yxy1JcRvEXUmGKD/8xFWvKMpGMffvmzgNRqJRFbfuB7F0qYLo=
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 00/11] tip/x86/nmi nmi-32/64.c merge v3
Message-ID: <4838373b.0637560a.7ce5.3f01@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series tries to merge down nmi_32/64.c to nmi.c. It is done by small
steps in hope it would help to bisect problems (which will appear anyway ;)
Please review *carefully* since it is NMI what I've touched (and I'm not
nmi specialist). So I really apreciate _ANY_ comments on this. The series
is produced over today 'tip' tree branch 'x86/nmi'.

		- Cyrill -

-- 
