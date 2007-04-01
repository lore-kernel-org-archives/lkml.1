Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXDAIWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXDAIWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 04:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932238AbXDAIWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 04:22:32 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:56011 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbXDAIWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 04:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pwfoPdfnm0Es3NlrhtpX1qJch1/76O8MLF4Eo2ne7hhVTHImMlJCP09nEt44nG6/U9FoEkDNLiGsZlFRNjl0txUTXUpVVKlrzsBdc2ztsES9n1wTt+JfVh0cDWghRHOfQiJwER/agXbgJl760kyvx//uyKa3mH1VVeEP2PEtXVg=
Message-ID: <82e4877d0704010122g24fcd0f2r717f98b1494225e6@mail.gmail.com>
Date: Sun, 1 Apr 2007 04:22:30 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: xiyou.wangcong@gmail.com
Subject: RE: [-mm3 PATCH] (Retry) Check the return value of kobject_add and etc.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-	kobject_add(&p->kobj);
>+	if (kobject_add(&p->kobj)) {
>+		kfree(p);
>+		return;

Please add a printk warning before the return statement to log a
proper warning stating what happened, which file and line etc. That
way people can know why something did not work as expected and
hopefully do something about it.

Parag
