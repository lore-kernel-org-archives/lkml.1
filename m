Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbZAOJKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbZAOJKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZAOJKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:10:13 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34295 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZAOJKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:10:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=HZvGH4uRnfTZiO0cHNt7JD3BaPMPLr4XaIv6cNO4wgQqmgZJBh852B/+WN+201DKGH
         SI5bKe/WHhHUuH5Gci4Jv7UZZJI1KzHmEbA4EIWVOEFOs4toJ81Sf4MJzHtgW1+Zd+P3
         x1ZwWvPqCM1KeOIO8MFyBeFxwbmA48dFd9H74=
Message-ID: <bcb3ef430901150110nc4ced93w50c662ac512f8552@mail.gmail.com>
Date: Thu, 15 Jan 2009 10:10:09 +0100
From: MartinG <gronslet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Suspend/resume works in 2.6.29-0.19.rc0.git9.fc11.i686, but fails in later versions
Cc: MartinG <gronslet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I run Fedora Rawhide on a Dell Latitude X1 and want to report on
failing suspend/resume on the latest kernel snapshots.
Smolt is currently not working in Rawhide, but an old profile of my
laptop can be found in [1]

In kernel-2.6.29-0.19.rc0.git9.fc11.i686 I have suspend(to ram)/resume
working, but in later versions, I am not able to get my laptop to
resume. I have tested these later kernels:
kernel-2.6.29-0.24.rc0.git13.fc11.i686
kernel-2.6.29-0.25.rc0.git14.fc11.i686
kernel-2.6.29-0.28.rc1.fc11.i686
kernel-2.6.29-0.31.rc1.git2.fc11.i686
kernel-2.6.29-0.35.rc1.git4.fc11.i686

None of them seems to let me wake up from suspend to ram.
I have used normal kwin (no desktop effects, no compiz).
When I open the lid, my wlan led lights up, but there is no hdd
activity, and the keyboard is dead.

Here's dmesg of the working kernel http://fpaste.org/paste/1459

Please let me know how I can test further and what logs to provide.

best regards,
MartinG
(please CC me on replies)

[1] http://www.smolts.org/client/show/pub_01507560-2bed-4c14-94a5-c72964bb4b84
