Return-Path: <linux-kernel-owner+w=401wt.eu-S1423184AbXBUWPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423184AbXBUWPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423185AbXBUWPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:15:42 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:25012 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423184AbXBUWPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:15:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mrw3vxRFt2+NFRjAZFP/oxuSvsFNTqw3p1twjTOQ73iLtkJoQsfhFd4QltjUCw8LCVqwoBpj/4ZdC84x9cotcL4UsA0V9xj62bpjsnC1t8F9maL2rvMTRYvqkJlyBWmsAjk1OaH533UrA2rVCNmZW9lA92LjecbUmptZA/CvGC8=
Message-ID: <e5ab0f710702211415p37444279td690c2db4b4ca8ab@mail.gmail.com>
Date: Wed, 21 Feb 2007 23:15:39 +0100
From: "Francesco Pretto" <ceztko@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Weird hard disk noise on shutdown (bug #7674)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, we are a couple of users suffering both the same problem: a weird
hard disk noise emitted when shutting down, immediately after the main
power is cut from the pc/notebook. We believe that the noise is a
symptom of an emergency head parking, usually performed on the drives
when the the power is forced cut off (for example consequently a
severe system crash). We are Ubuntu users, but other users tried various
distros observing similar behavior when comparable settings are used
(e.g. using libata drivers). Ubuntu bug managers have decided that is
kernel drivers issue [1] and a bugzilla entry was opened [2]. The bug was
issued on 2006-12-20 but since that there hasn't been much interested on
it, except from other users worried about their notebooks' health. It has
been conjectured that this is a libata specific problem, because using
legacy ide drivers for the same disk (when possible), this "fix" the
problem.

Now, what we'd like to know is a clear word if this a distro specific
bug or a kernel one (it should be enough to establish if the
responsibility of safely parking the disk head is of the shutdown
script or of the controller driver). In the latter case, we'd like to
enter in contact with the related subsystem maintainer so we can help
to track down the bug (some details are already present in the related
bug entries on bugzilla and launchpad). After all, this seems a bug that
could injure the disks in the long time. Even if this is not the case, it's not
good that people (especially newbies) believe that using linux is not
safe for their hardware :-D .

Thanks for your interest,

Francesco Pretto, ceztko at gmail dot com
Giorgio Mennea, swengml at gmail dot com

NB: Please CC the sender's email. I'm not subscribed.

[1] https://launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/67810
[2] http://bugzilla.kernel.org/show_bug.cgi?id=7674
