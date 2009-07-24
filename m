Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbZGXPcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbZGXPcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZGXPcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:32:00 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:57619 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbZGXPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=u4btP8BUIdQ2xEqS8dNRBX4nESkrwhRL6iSjEmLi7u9cRlnnpTkFT/x6UaQyoiUeeI
         +K/UPw6it9nF4chd0Qk7uDEBx0m26ti6k1sK3TpZcy/kvNmqe8pd553a/pYGZnT/qmNN
         0eUGKQEMy+vbBPOKUHgqcECMJhzoCvQMfMgVc=
MIME-Version: 1.0
Date: Fri, 24 Jul 2009 21:01:59 +0530
Message-ID: <f5a7b3810907240831t75a058a2m96abdc28a28c4365@mail.gmail.com>
Subject: Char Limit issue on 2.6.29 kernels
From: naresh kamboju <naresh.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tim.bird@am.sony.com, ltp-list@lists.sourceforge.net,
       brinda_mn@yahoo.co.in, rohit.170309@gmail.com,
       Garrett Cooper <yanegomi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       maxin john <maxinbjohn@gmail.com>, Masatake YAMATO <yamato@redhat.com>,
       michal.simek@petalogix.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have come across with char Limit issue on 2.6.29 kernels.


SIGFAULT:

#define SIZE            8053759
char buf1[SIZE] ;

NO SIGFAULT:

#define SIZE            8053758
char buf1[SIZE] ;

This SIGFAULT not observed on 2.6.23 kernels.

What could be the changes that effecting from 2.6.23 to 2.6.29 kernels.
Please share me the information.


Best regards,
Naresh Kamboju
