Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYCZKL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYCZKL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYCZKLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:11:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:42161 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYCZKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pkabZ7a1jZ6IVpfqgXfoadYqvpZIWdoXAUEFT4mI/8byHZ7QJngY7M9WhNe9gKwb9k33JShdRVtHpli3SAhzyW6TzOO/3qZK8aJE2QNK9ZspwG4Gm/HZr4iFe5ZXIQdlxNGfmdSzxB3lq6PfDPxlDcc42cdOJGTmR0KISIn2cHg=
Message-ID: <e1d5030b0803260311j25831caeyd9fc111a06e572e2@mail.gmail.com>
Date: Wed, 26 Mar 2008 15:41:16 +0530
From: "Midhun A" <midhunagni@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Userspace - Kernel Space "Connector" test
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

   I want to use the Connector module (CONFIG_CONNECTOR) for Kernel
space to User space communication.  My kernel version is 2.6.22.
Before using it, I am trying out the example programs in the
Documentation folder. I have cn_test.c built into the kernel (not
loaded as a module) and I have compiled ucon.c.

When I run ucon, the programs hangs at the point it polls the socket.

	while (!need_exit) {

		printf("Entered While\n");	
		pfd.events = POLLIN;
		printf("1\n");
		pfd.revents = 0;
		printf("1.1\n");		
->	      switch (poll(&pfd, 1, -1)) {

The source code is the same as in the kernel/Documentation/Connector folder.

How do I get to know whether it is listening to the same socket as
cn_test is sending message on?

Thanks,
Midhun.


P.S.: I am not subscribed to the list. Please CC me.
