Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYFHVZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYFHVZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYFHVZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:25:39 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:25679 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbYFHVZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=IDnFSWHRbZ3XGro7CQldKM8dBPl7YHjunW53kQKbnZ20KDCPsdY+A2kKDcG1a/6EFa
         qrQj/qSF4jSt42le3W9ZF3k6Vp5wDSt5iSwb0m889wKLNeNeGKYJE7kETZ+b8hLwkl0Z
         By9WA8HO+cHNsqwab01BLASc/ErfSio5aKF5s=
Message-ID: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
Date: Sun, 8 Jun 2008 14:25:36 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Is configfs the right solution for configuration based fs?
Cc: "linux kernel" <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       "Joel Becker" <joel.becker@oracle.com>,
       "Satyam Sharma" <ssatyam@cse.iitk.ac.in>,
       "Felix Fietkau" <nbd@openwrt.org>, "Al Viro" <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was really interested in looking to start a filesystem based
approach for configuration of wireless a while back, an alternative to
nl80211 if you will, but I stopped after I was told about some major
issues with configfs. I forget the issues raised clearly so I'd like
to bring this up for debate to see what really are the issues, what
needs to be fixed so we can *properly* use a fs for configuration of
subsystems. I thought configfs was the solution. We currently use and
abuse debugfs, but it doesn't matter -- we don't expect users to
depend on those files for ABI. It, however, it would be nice to
finally export some of these values into a concise place so userspace
*can* rely on them.

I'm ultimately looking for an option to reduce the size of the kernel
you'd need for wirless configuration, or at least to make easier for
userspace. Don't get me wrong I'm not saying I want an alternative to
nl80211 -- I realize we already decided on that and are moving along
in that direction, I'm just wondering once that is done what is the
right place to look at and if we don't have anything what are the
things we need to take into consideration so we *do* use or implement
the *right thing*.

Perhaps a fs is not even the most optimized approach for size anyway
so the benefits may just be helping with the easy design of userspace
applications. Feedback on experiences are welcomed.

PS. I'm hoping those who *really* hate configs can comment

  Luis
