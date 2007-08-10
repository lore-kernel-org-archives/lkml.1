Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXHJFTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXHJFTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 01:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbXHJFTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 01:19:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:6045 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbXHJFTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 01:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Tuizs2Dr6+xOJzm9KvGk/hiB/wuux9/+Y2wTgvbb2sPBpbCDMI/wTOZCZygVT2UhD5tdJchk//5M9dY2BSevlOk6lQL3EpN9i3gU5/uNB6YfjYuEMeiwJIaqwDVsX260qRReLAYnQkstYiX6QCJxXZViwz8Go4O7gRtqI+/TAg0=
Message-ID: <4104961b0708092219r6fbc5854pc41a4a98a2b79c2a@mail.gmail.com>
Date: Fri, 10 Aug 2007 13:19:45 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about PF_NOFREEZE
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

if one thread set its current->flag with PF_NOFREEZE, then it means
this thread is unfreezable,does this mean, when the system entered
into a suspended state, even though all the other threads have already
gone sleep, this thread still keeps awaken?

One thing I am very confused is, if all the other threads goes to
sleep,can this only one thread(assume only one thread marked itself as
unfreezable.) still works well?

Regards
Jason
