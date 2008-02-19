Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYBSLBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYBSLBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYBSLBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:01:01 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:10405 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbYBSLBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AZVcZ6zQVDl77+JoTEK9n+fYy538uWPxzx61Gnc4cVHSNYaKkHFZkjUdfdGSlju6o55TUo0WzPhkt2jrRhten4OS4dcU03Hvfsy3xPQ9oovTfnJ9aEyRQD1lS5/it9OjW0XQSKmxNp5rb3930W+U2oNQS6G6+UKWLwSQJVM1UQk=
Message-ID: <e2e108260802190300k5b0f60f6tbb4f54997caf4c4e@mail.gmail.com>
Date: Tue, 19 Feb 2008 12:00:58 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: SMP-related kernel memory leak
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed that the amount of memory used by the Linux kernel steadily
increases over time on SMP systems (x86 architecture, 32-bit kernel).
This problem disappears when I add maxcpus=1 to the kernel command
line. I have observed this behavior both on the 2.6.22.18 and 2.6.24.2
kernels. Did anyone notice anything similar ?

See also: http://bugzilla.kernel.org/show_bug.cgi?id=9991

Bart Van Assche.
