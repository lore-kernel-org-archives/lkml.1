Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbYIJGzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbYIJGzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYIJGy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:54:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45378 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbYIJGy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:54:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48C6F913.1010509@goop.org>
	<86802c440809091554y349366fdu8e4ca59797ab4205@mail.gmail.com>
	<48C70ADC.8060004@goop.org>
	<86802c440809091726y4db8f85eg2d478b482862c5f9@mail.gmail.com>
	<48C719C0.6060201@goop.org>
Date: Tue, 09 Sep 2008 23:45:23 -0700
In-Reply-To: <48C719C0.6060201@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 09 Sep 2008 17:50:08 -0700")
Message-ID: <m1zlmglcsc.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: jeremy@goop.org, linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0358]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: TARGET_CPUS in assign_irq_vector
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> 3) give up because the idea is fundamentally ill-conceived, or 4)
> something else?

Yes.

When working with event channels you should not have any
truck with vectors and you should not call the architecture
specific do_IRQ().

Eric

