Return-Path: <linux-kernel-owner+w=401wt.eu-S939679AbXGSPyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939679AbXGSPyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938578AbXGSPyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:54:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:36602 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935902AbXGSPyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hxRMFVN/HMBt18NyOq7BrdvKiGJdRuHh5rqabkhYu4LmHr00iIAQCWRs6kxWqHlrgcYY8eyFMLWoVZtL5q9tIuDO+LApY3d9DakD5WxJ88uzLfWpKxTzmYwePWZGXqBcXMtF+/g10dVOLD38ycOf7bXIetA1bdYQklZHQyLeOH4=
Message-ID: <ab18d8520707190854v50216497mcc2be291d1a99ab2@mail.gmail.com>
Date: Thu, 19 Jul 2007 23:54:01 +0800
From: "Fengwei Yin" <yfw.kernel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: About get_page for compound page
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
In get_page(), the parameter page is changed by
         page = compound_head(page);
if the page is not the first page of compound pages.

My question: is this behavior correct?

Regards
Yin, Fengwei
