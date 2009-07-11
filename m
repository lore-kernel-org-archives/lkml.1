Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZGKJTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZGKJTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 05:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZGKJTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 05:19:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZGKJTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 05:19:22 -0400
Subject: [FIX REQUEST] Need better management for include/linux/*.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: nicolas.ferre@atmel.com, hskinnemoen@atmel.com,
       Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 14:48:48 +0530
Message-Id: <1247303928.2678.46.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

As include/linux/*.h file count is going to reach 1000.

We need to do some better techniques to reduce the number of files and
add some hierarchy levels like sub directories where possible.

Like atmel is not exporting to user-space we can easily do :

include/linux/atmel-mci.h     -> include/linux/atmel/mci.h
include/linux/atmel_pdc.h     -> include/linux/atmel/pdc.h
include/linux/atmel-pwm-bl.h  -> include/linux/atmel/pwm-bl.h
include/linux/atmel_pwm.h     -> include/linux/atmel/pwm.h
include/linux/atmel_serial.h  -> include/linux/atmel/serial.h
include/linux/atmel-ssc.h     -> include/linux/atmel/ssc.h
include/linux/atmel_tc.h      -> include/linux/atmel/tc.h

Also these files are not exporting :

include/linux/kvm_host.h      -> include/linux/kvm/host.h
include/linux/kvm_para.h      -> include/linux/kvm/para.h
include/linux/kvm_types.h     -> include/linux/kvm/types.h

Similarly for other files, where possible.

Thanks,
--
JSR



