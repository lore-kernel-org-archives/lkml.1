Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZJSIQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZJSIQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZJSIQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:16:53 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37265 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbZJSIQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:16:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=nraKP2Y1EFqNtdzsl5v7lIi1wJ1KwzF0b/FdN+hS6PDSS99KlYw2DD4W+HYzLb0mlM
         Gh9BiXef/wvd4Rpn/MKFr3ekCMVse6vBo0D/nrbl9SIDvwivWY7grjAqgMMNvkilG2G/
         elTcJCuD3vBn2VbsQZndys8Vvl+p7okvDe8hI=
MIME-Version: 1.0
Date: Mon, 19 Oct 2009 16:16:56 +0800
Message-ID: <f2201a0b0910190116w29cd5e3w1ae2c76bd677f9ed@mail.gmail.com>
Subject: Question about invalidate_inode_pages2_range()
From: Peng Tao <lkml.bergwolf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've a question about invalidate_inode_pages2_range().

When does invalidate_inode_pages2_range() returns -EBUSY? It locks and
writes back the page. Why invalidate_complete_page2() still may fail
due to page dirtiness?

TIA.
