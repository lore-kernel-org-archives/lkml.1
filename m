Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYLCSLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYLCSLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYLCSL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:11:29 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:26698 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYLCSL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:11:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=r3+yJjD/ZC3uZwsMF0N9zQpCqoluFMwJzrE7qQO76AMFVi39kejUfx09tVO5XsPWXF
         JFGtFpoUfbMlVbuo5T5XuBthiSZArEHfAYZIzmLkxL5132WNObXqDX0HOmJOSRbUcCj+
         AaYOm5aNBzgFSVm4a77mfkavUSAddDiz+cO5A=
Message-ID: <4eea36270812031011x5f014b04q352af666cacb2f93@mail.gmail.com>
Date: Wed, 3 Dec 2008 10:11:26 -0800
From: "Russell Miller" <duskglow@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: nfs NULL procedure packets
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again, I was hoping someone here could answer another question.  I
apologize if these are easy questions...

So a couple of days ago I was troubleshooting yet another NFS problem
(not the non-one I described a few days ago).  I sent a 1G file over
to a server, did a TCP capture, and analyzed the results.

I noticed a lot of NULL procedure packets.  A *lot* of them.  In some
cases, one every 10 microseconds, and there were about 400,000 of them
I captured.

This seems like a lot of network traffic for very little reason.

Is this normal behavior, or something I should investigate further?
It seems to me like pinging the NFS server once every 10 microseconds
is a major waste of bandwidth.

--Russell
