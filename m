Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYFVSJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYFVSJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 14:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYFVSJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 14:09:20 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:11839 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbYFVSJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=CM7hC2j/87VdOWOSZY21F+qZ5ccjUvx1wKvBD1SpLFVJ0Kin9eOILDguHnpxRHlU+i
         RXZm0rdeyPthRMWmEkA+fUGofNb7gG5PEI15zF0ACp22Sb1+hnZ+h+pUcD7RAtBC9/qe
         uUPiow/moHCuBkcmyVKs8AzhDO3zjWqejuyW0=
Message-ID: <dd18b0c30806221109t2ff73f9ai52f6716748648a79@mail.gmail.com>
Date: Sun, 22 Jun 2008 18:09:16 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: stuck tcp connections 2.6.26-rc7
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I too am experiencing internet connectivity problems, for  a
while I thought
It was due to low bandwidth(or being ddos attacked) but yesterday I
noticed with watch netstat -ntu
send-Q was stuck on a number; the connection would not go to TIME_WAIT
resulting in music to pause, and t.v. to freeze.
In my experiences running xmms streaming music is fine, no problems,
but as soon as
you watch something with flash player the stream start's getting
really bad. In the past with older kernel's
I usually can watch t.v.(with flash) and stream music at the same time
without any trouble.
lately I've been Running the kernel in No forced Preemption with a
time frequency at 100. having the kernel set in this mode really shows
the connection problems, but if I change the preemption to another,
and bump up the timer frequency the poor internet connection is not as
bad(or stuck tcp) but still prevalent. more pops in the music, and
sudden internet loss for around five seconds, then goes back
So from over here streaming music has no problems from what I can see,
but as soon as I watch media, it becomes a mess.
regards;
-- 
Justin P. Mattock
