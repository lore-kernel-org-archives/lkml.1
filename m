Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbZCBFHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbZCBFHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 00:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbZCBFG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 00:06:59 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:49627 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZCBFG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 00:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=l+xNtkiely8icqwNg0VIK2yLoz7cc7igaN9BOOkY3MCkDGSy6lXQi26URIdLDtq8Is
         avheuXQvRf8hOKMnDGbGWzAY17nvNtbRtx6inWOV2hwUbr8iTzk2ALk51khVRsqUOfjO
         sdiYSwqOvVns9lSnNClUACWdaqB9GXtCKdsfM=
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 13:06:57 +0800
Message-ID: <d364733c0903012106g2625d433o4cdbbbcc5a9ff19a@mail.gmail.com>
Subject: The difference of request dir between AS and Deadline I/O scheduler?
From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm little confused about the defination of request dir in AS and
Deadline I/O scheduler.
In AS, the request dir is defined by wheher it's sync:

data_dir = rq_is_sync(rq);

But in Deadline, the requests are grouped by read and write.

Why is there the difference since AS is an extension of Deadline?
what's the consideration?

Thanks,


-- 
Xie Gang
