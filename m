Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYIIWaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYIIWaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbYIIWap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:30:45 -0400
Received: from gw.goop.org ([64.81.55.164]:37272 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736AbYIIWao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:30:44 -0400
Message-ID: <48C6F913.1010509@goop.org>
Date: Tue, 09 Sep 2008 15:30:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: TARGET_CPUS in assign_irq_vector
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86-64, the genapic implementations of target_cpus returns
cpu_online_map.  What if more cpus have yet to come online?  Shouldn't
it be cpu_possible_map?

Though I'm probably confused.  I don't really know what the intent of
target_cpus and vector_allocation_domain is.

Thanks,
    J
