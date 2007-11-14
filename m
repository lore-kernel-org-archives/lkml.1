Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbXKNL1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbXKNL1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbXKNL1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:27:08 -0500
Received: from s200aog17.obsmtp.com ([207.126.144.131]:52488 "EHLO
	s200aog17.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbXKNL1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:27:06 -0500
X-Greylist: delayed 1366 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 06:27:05 EST
Message-ID: <473AD62E.2030805@st.com>
Date: Wed, 14 Nov 2007 12:04:14 +0100
From: Richard MUSIL <richard.musil@st.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with http access to stable git - linux-2.6.23.y
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am experiencing problem when accessing 2.6.23.y stable git over http.
In my config I have:

[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
        remote = origin
        merge = refs/heads/master
[remote "linux-2.6.22.y"]
        url = http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
        fetch = +refs/heads/*:refs/remotes/linux-2.6.22.y/*
[remote "linux-2.6.23.y"]
        url = http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
        fetch = +refs/heads/*:refs/remotes/linux-2.6.23.y/*

Which basically means I am cloning Linus' git and fetching stable branches.
For linux-2.6.22.y it has been working fine so far, but for linux-2.6.23.y
I am getting:

> git fetch linux-2.6.23.y
Cannot get the repository state from http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git

I wonder if I have misconfigured something or there is some difference
between 2.6.22.y and 2.6.23.y on server side.

Please note, I cannot use git or ssh instead of http, because I am behind
corporate firewall/proxy.

Richard
