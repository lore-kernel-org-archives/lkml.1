Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYAYQiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYAYQiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYAYQip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:38:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:63239 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYAYQio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=TnTo41jPJskFjEznKRjzbAYdZIvrKW5btgiKjSdaY8B0ekHY7VT5HhLS713TieRqGEv0NODlHsviWgaGp/MXJCngyfmsO+P51FQavUN9kK+8U9eEmR8ZpJoIUSq2ahbhFYgwAhIecHi6MPIPX7P9zDda4WHJywTAy0tHhOo/rLs=
Message-ID: <3d8471ca0801250838h2d1f21f2n95c70bc26e28d310@mail.gmail.com>
Date: Fri, 25 Jan 2008 17:38:42 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Dropping some patches from sched-devel
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 90b874a0214efe24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Can I talk you into dropping these patches of mine from sched-devel
(or not send them to Linus):

da0f9440cdcb1edd5424de91f326de83de3fe5f9 sched: make sure jiffies is
up to date before calling __update_rq_clock()
6eb300ad38fef6db4efe177067a65aaa771596da sched: fix rq->clock
overflows detection with CONFIG_NO_HZ

They are not of good enough quality, and I'm working on a better approach.

Thanks.

-- 
Guillaume
