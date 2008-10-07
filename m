Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYJGEYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYJGEYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 00:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYJGEYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 00:24:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:9654 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYJGEYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 00:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding
         :mime-version:subject:date:cc:x-mailer;
        b=pn/aXyKZp/S3um9NI/7SAhowUWFj3yzwdzWFoMvorvB4BdcbNc5rTfjsrUmobrzWME
         UmDHxGCoTqLHtEgWJnVALTp+mFGSiknZ5SwyraeLX1I5IS1xXasK2ykttHuMGofzN++L
         +La7asqOMta5JAAwnO2BIt07BgYoO/hiB+Yls=
Message-Id: <F99FEC4F-DEDD-4E55-93B4-A0761F30E1A2@gmail.com>
From: Richard Holden <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: BKL still required for what functions?
Date: Mon, 6 Oct 2008 22:24:12 -0600
Cc: mingo@elte.hu
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm doing some driver cleanup on the ixj telephony driver, mostly copy/ 
paste and common code refactoring. I'm also looking at trying to get  
rid of the BKL from the 2 places its used, so I was wondering if we  
have a list of kernel calls that still require the BKL to be held, and  
if we don't have a list would it be worthwhile to put one into  
Documentation, I'd be willing to maintain the list as we removed the  
BKL from the last core kernel places.

-Richard
