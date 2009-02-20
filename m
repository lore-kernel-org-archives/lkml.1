Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbZBTWWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbZBTWWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZBTWWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:22:00 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:8288 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZBTWV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=m/x7Ge8Cb0gA2xyyInubObwXR2EDAIXrqZuCLm4tk5RD3YpJLDNJStRx1ic/cEIabS
         wAqC2U3VMeeMl0f2GJJ2udaT8oZWs2q/OIB6ntKkn0VpPmrlKGc4n7e2BzchgSJyAtRb
         SoxeKUQ48tkfSBsCjzsF9Llj0X0lE4ng9Ltz4=
MIME-Version: 1.0
Date: Fri, 20 Feb 2009 23:21:58 +0100
Message-ID: <d6c8ef150902201421lf93dcf0j7b0dfae7f0e94f17@mail.gmail.com>
Subject: AT91SAM - 9-bit Serial mode
From: Bosko Radivojevic <bosko.radivojevic@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-arm@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have AT91SAM9260 and have to use it's serial in 9-bit mode. It seems
I'll solve my problem with little modifications of atmel_serial and
use of multidrop parity (when sending) and reading parity errors when
receiving. If there is something more controllable (from the user
space) or some ongoing project focusing 9bit mode, please let me know.
I've noticed some -9bit kernel trees, but quite old.

Thanks

Sincerely,
Bosko
