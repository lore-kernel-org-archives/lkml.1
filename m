Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYBQKzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYBQKzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 05:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbYBQKzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 05:55:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:48534 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbYBQKzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 05:55:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hCgSNZSYI6XKCRIs0REgEhZhiU3EM+gyjk4RNXG9BTr9ChDGYsPTaP7Xvmy//aBk8PTY9vCijJbUJPfNpkBjmzS2wuf5HPs5NKAy8eroY1ZmWOvuSvSOlYtS/hjCYPkfuUa/BxyCEDH8qI1bPo2zdrQfChaEOBn5YVx16jT0SeE=
Message-ID: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com>
Date: Sun, 17 Feb 2008 11:55:02 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: My system stops during startup with curretn git tree of 2.6.25-rc2
Cc: panther@balabit.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It looks like there is something weird as my systems stops when the
swap is mounted.
I've played bisection game and this is the commit which makes the
system unusable:

# bad: [45b503548210fe6f23e92b856421c2a3f05fd034] [RTNETLINK]: Send a
single notification on device state changes.
git-bisect bad 45b503548210fe6f23e92b856421c2a3f05fd034

I've tried to reverse this commit - and it has compiled & worked.

Zdenek
