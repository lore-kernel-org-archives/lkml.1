Return-Path: <linux-kernel-owner+w=401wt.eu-S934542AbXGLNRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934542AbXGLNRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbXGLNRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:17:11 -0400
Received: from ns.firmix.at ([62.141.48.66]:57608 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721AbXGLNRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:17:09 -0400
Subject: Re: Fwd: NPTL
From: Bernd Petrovitsch <bernd@firmix.at>
To: "Ni@m" <niam.niam@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a9e22dff0707120558k17ca1f86rb0044096d60c4dc1@mail.gmail.com>
References: <a9e22dff0707120518t77d440d3ue0368fd1f3e36c03@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKCEOCFDAC.davids@webmaster.com>
	 <a9e22dff0707120537l1a29de93vdd67f146cf36a120@mail.gmail.com>
	 <1184244078.20032.48.camel@twins>
	 <a9e22dff0707120557t574f9383g5363c26074ea6d6a@mail.gmail.com>
	 <a9e22dff0707120558k17ca1f86rb0044096d60c4dc1@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Thu, 12 Jul 2007 15:16:58 +0200
Message-Id: <1184246219.14038.28.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.326 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.326 required=5
X-Spam-Score: -2.326 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 15:58 +0300, Ni@m wrote:
[...]
> >>No, a process also contains an address space.
> Of course .. I ment they are _almoust_ similar.

Not really. A process has one or more threads, (virtual) memory, open
file descriptors, a uid, a gid and several other resources.

Historically there were only "processes". "Threads" were invented later
on so there is (usually) some confusion remaining  here .....

> >>No, that is creating a schedule unit (task) without an address space.
> Ok, I've already found that in kernel code ... and correctly understood.
> 
> >>Surely you need some context switch when switching between runnable
> contexts.
> Hm. If the thread is running after it's sister or parent process - you
> do not have to switich the process context. Is this done in kernel??

"switch process context" is misleading wording - "task switch" is better
(and "task" is usually the kernels view on a thread). You have at least
to store the registers of the old task somewhere and load the ones from
the new task.

> Sorry if my thought are idiotic .. I'm a newby and trying to
> investigate the kernel.

Hmm, you might invest in a book about operating systems to learn the
basic concepts.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


