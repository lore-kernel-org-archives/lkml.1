Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYH1DDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYH1DDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 23:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYH1DDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 23:03:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:50857 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYH1DDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 23:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=O7f5EpMSdd6btEyJ71LHxRYSu0r2jQEseJwdGUl1mOaz+y2ZIMRU3DSnHL5fgR7NHQ
         eDDu1sA3OO3MYopNXE9PRcwvEDnAQdtn9dh/IpXHi/zBCV0JLW8xk1wltTdcN8OFhyah
         vsmpmztaK8UpTmh0flZ6TM/JJlRJekpcAF4D0=
Message-ID: <632b79000808272003m58cc5b32i8f44b563a4ba89cf@mail.gmail.com>
Date: Wed, 27 Aug 2008 22:03:02 -0500
From: "Don Dupuis" <dondster@gmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: 2.6.18 very slow sync to disk with ext3 fs on an md raid10 array
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a 12 drive system running 2.6.18.8 with a 11 drive md array.
This array is setup with raid10 and a combination of ext3 and ext2
filesystems. The issue I am having is this. I transfer a 180MB file
with scp to the ext3 filesystem. When this is complete, I will then do
a sync to make sure it is written to disk. The problem is that it will
take 6 MINUTES for the sync to complete. If I do the same thing to the
ext2 filesystem, it will take about 6 seconds. I know that 2.6.19
kernel solves my problem, but the project I am working on requires
2.6.18. I am trying to figure out which patch or patches that went in
to 2.6.19-rc1 fixes this. PLease give me suggestions. I will give
needed data that will be asked for. One more thing, this is an X86_64
kernel on an Intel quad core processor. The disk controller is an LSI
sas controller.

Thanks

Don
