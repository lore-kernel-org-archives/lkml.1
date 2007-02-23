Return-Path: <linux-kernel-owner+w=401wt.eu-S1750701AbXBWCrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750701AbXBWCrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 21:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbXBWCrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 21:47:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:32376 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbXBWCrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 21:47:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NaxmjUAsxw/eJ/+Rm9+AIM/g70pSbG2aPoQkVLcatnVqi9mx5xMiC0dsHs2WyS2XUh12Wg7dYJ7ZUuo3wtibOv17Qpczr/0s+GfbIgUkD+YiYrlF+nqelpHkQycVFCNgwZg9FJM0kghp23IUc8OFFvRnr0xRqoawBPjoL8SPZlw=
Message-ID: <a2ebde260702221847q6710be1sbf2d28f37ab4fb2b@mail.gmail.com>
Date: Fri, 23 Feb 2007 10:47:01 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Why __syscallN macros are removed?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __syscallN series macros have disappeared in
include/asm-i386/unistd.h. Why? I occasionally what to add and use
some new system calls, mainly for debug use. Now I can not access the
system call I added from user space.
