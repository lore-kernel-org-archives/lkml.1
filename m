Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZLTMW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZLTMW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZLTMWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:22:25 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:48624 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZLTMWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:22:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Ynr/h+6IyP6jWmZ7FPjXDviMlRPEcHv1jb4ekE0S2S/yK9IFjs+ewPTCItQDz4UjHm
         JPilI5Ps3DYn3qe3rA+TIBvHPbP095w2ofa5AIArnpdVmajTE4TawKYG4LPMiYuX9ZfN
         D+Cqj80g2l7rhIQmzDj7uJr+l2WpLg0wi6zJ0=
MIME-Version: 1.0
Date: Sun, 20 Dec 2009 17:52:23 +0530
Message-ID: <3a9148b90912200422j1b0b008dp90d0e0cd44ccf31d@mail.gmail.com>
Subject: A question about Byte range locking.
From: Dhruv Matani <dhruvbird@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I was reading the kernel code to try and figure out how byte range
locking is implemented inside the kernel, and it looks as if it is
implemented using linked lists of locks which store the range locked
and the type of lock. Am I right??

-- 
   -Dhruv Matani.
http://www.geocities.com/dhruvbird/

"How do you know when someone's crazy?"
"Well, you don't always. Depends on how many people think they're crazy."
    -- Rumble Fish.
