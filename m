Return-Path: <linux-kernel-owner+w=401wt.eu-S1765535AbZA2Acl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765535AbZA2Acl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760527AbZA1X5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:57:18 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:43149 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760339AbZA1X5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:57:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kbt+mf8EX40XPDQbOQ9wPc+T2rmYOy4X5QV2V32zuQcWR9hKkUDW00oHmYP8NXzN7E
         SUhmAQGNIkCVE2CEr5L2QBXZztZf19PM19HTbcuDcQ4JFLJwjHG6dn3SsMxQJhpTsPde
         s6M+dJR69XnTY9OaxhpA0m23gfixtaZp+ZR/c=
MIME-Version: 1.0
In-Reply-To: <20090128235514.GB24924@barrios-desktop>
References: <20090128102841.GA24924@barrios-desktop>
	 <1233156832.8760.85.camel@lts-notebook>
	 <20090128235514.GB24924@barrios-desktop>
Date: Thu, 29 Jan 2009 08:57:15 +0900
Message-ID: <28c262360901281557r295f65e0i2aed4d4d14fdbf52@mail.gmail.com>
Subject: Re: [BUG] mlocked page counter mismatch
From: MinChan Kim <minchan.kim@gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux mm <linux-mm@kvack.org>, linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed my test program.

#include <stdio.h>
#include <sys/mman.h>
int main()
{
        mlockall(MCL_CURRENT);
        // munlockall();
        return 0;
}


-- 
Kinds regards,
MinChan Kim
