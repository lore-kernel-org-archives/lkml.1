Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZKKBCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZKKBCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 20:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZKKBCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 20:02:10 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:52641 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbZKKBCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 20:02:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=HfcbE0WagNeGNz75Rlnmg30+oLweR6QZZr8tl53O2ZkmROEWe6PPmLbN/B7TCGmjv/
         XoDRI+09+6Fopj6ltAkc2nrN9xgXULmxavf1RqcYG9GyCXxgILwKKbY0vBOYZJObrYH6
         Uhbwaf9EGnIJ+S0Am0jggpLH9YQjEZu+HS3Dk=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Nov 2009 17:01:55 -0800
Message-ID: <43e72e890911101701g4250f59ar73a929114e21ae2e@mail.gmail.com>
Subject: lpj=x loops_per_jiffy option enhancements
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lpj argument seems nice but it seems busted for SMP. I was
wondering since this is a common thing for some embedded devices can't
we just stuff the lpj somewhere after our first boot and remove this
as an option?

Where we store it ? I don't know... we managed to store an image for
suspend, seems we can find a place for lpj, no?

  Luis
