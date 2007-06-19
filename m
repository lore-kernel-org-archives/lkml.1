Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXFSJLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXFSJLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbXFSJLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:11:42 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:23903 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbXFSJLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sG7LF71GMobROH/TTUAacjwX8pb4EQYFTc1N5cntBEbS76rzyDar7PQ14Ol0gEc4oCid4tbEuIayK/cg/yZxtrmidCebOVrsUuX3kh15enXGbGSC4FqJS1tPMJ9I0swTXQtz/u9CCu7ixMOLjAWq6A1dfY+h7l7+MVmu0cjBeK0=
Message-ID: <ab18d8520706190211v1a5b4a17u57d0927400e15a5e@mail.gmail.com>
Date: Tue, 19 Jun 2007 17:11:40 +0800
From: "Fengwei Yin" <yfw.kernel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Type error in drivers/input/tsdev.c?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
In function tsdev_event() of drivers/input/tsdev.c,
conversion from usec to milisec is like:
    client->event[client->head].millisecs =
		time.tv_usec / 100;
			     ~~~~~~ should be 1000?

Regards
Yin, Fengwei
