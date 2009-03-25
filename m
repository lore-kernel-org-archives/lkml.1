Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZCYMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZCYMp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761705AbZCYMpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:45:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60235 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761145AbZCYMpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:45:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=SLZoZw7my7l/xJW8ooKjfxhM408LuGN9068rywuntgoS3VBzmH/LhTuh7JokxzAQR8
         +EudJCnuZkL5aH3vt8bDPFdQDnC6P2yX/VGwk0lssYQvMaNHUEQLM8iVeh0FevsvLhMS
         4zR0jKHN25v/oV/kidMcjk65a/kkD942uRGQw=
MIME-Version: 1.0
Date: Wed, 25 Mar 2009 13:45:01 +0100
Message-ID: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
Subject: epoll_ctl and const correctness
From: nicolas sitbon <nicolas.sitbon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the prototype of epoll_ctl is :

int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);

I searched in the man of epoll_ctl and google, and it seems that the
structure pointed to by event isn't modify, valgrind confirms this
behaviour, so am I wrong? or the good prototype is

int epoll_ctl(int epfd, int op, int fd, struct epoll_event const *event);

Thanks by advance!
