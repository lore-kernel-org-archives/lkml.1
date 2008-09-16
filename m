Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYIPOQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYIPOQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYIPOQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:16:39 -0400
Received: from zulu.prosoftsystems.ru ([195.58.8.33]:62791 "EHLO
	zulu.prosoftsystems.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbYIPOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:16:38 -0400
From: Alexander Pazdnikov <pazdnikov@prosoftsystems.ru>
Organization: PROSOFT SYSTEMS
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.26.5-rt9
Date: Tue, 16 Sep 2008 20:16:55 +0600
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809162016.56330.pazdnikov@prosoftsystems.ru>
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0278], KAS30/Release
X-SpamTest-Info: Not protected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

static inline ftrace_event_irq was removed from include/linux/ftrace.h that was in 2.6.26-rt1 patch

/arch/arm/kernel/irq.c:118: error: implicit declaration off function 'ftrace_event_irq'

It forced to delete this call, but is it possible to fix it correctly?
Otherwise kernel failed to compile.

-- 
Best regards,
Alexander Pazdnikov

