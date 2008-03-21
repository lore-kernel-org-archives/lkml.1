Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbYCUVKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbYCUVKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761892AbYCUVK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:10:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:45074 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbYCUVKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mSuNHVzJbcox7TmrvMgT7uQ5s1Ah6fkJi9cQvTvN6idkTyvuOcxHFG4mdK3KwYsP7E5euxBKP+SCZnzAGj3bHYrTOyQ/vU+JXA7uZ+xeIkuBWzlcBCj8TE4gLubk4cZqfMp1uzjE1H1cpb08k3Ybb0+nJEKSVbr0LsOizlDZpt0=
From: Madhou <madh2001@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: shell outputs anything typed when the kernel thinks@100%
Date: Fri, 21 Mar 2008 22:11:43 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803212211.43833.madh2001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel: 2.6.21.5
OS: Slackware12.0


This is a long time annoying misconception i'm reporting here:

When a command is run from a shell and drives the kernel to use 100% of cpu 
for a while, linux lets printing on screen anything that is typed.
This doesn't sound too much annoying at first sight, but actually this 
confronts the users to a problem:
When logging in a shell, one will type his username, 'return' and then his 
password...
But just after 'return' the kernel is launched into thinking for long enough 
to the point that users who do everything fast including logging in a shell 
let the shell display the first letters of their passwords.
This problem tends to be critical when the user makes a demonstration to a 
bunch of people thanks to an overhead projector.

The time that the kernel takes for checking usernames is about one second on 
my laptop which is equipped with an intel centrino 1,7GHz.
