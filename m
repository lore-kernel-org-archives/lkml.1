Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZB0JKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZB0JKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZB0JKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:10:31 -0500
Received: from mail.lang.hm ([64.81.33.126]:49679 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbZB0JK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:10:29 -0500
Date: Fri, 27 Feb 2009 01:10:24 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: ip_nonlocal_bind and sendto
Message-ID: <alpine.DEB.1.10.0902270049440.7158@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a need to forge the source IP of UDP packets (a stupid syslog 
receiver app that I need to deal with)

I know that this can be done with raw sockets, but with the 
IP_nonlocal_bind option I thought that it may be possible to do this 
without dealing with raw sockets

so I have an app that does the socket call, followed by the bind call 
without any errors, but when I issue the sendto call it generates error 22 
(invalid parameter) if the source IP doesn't exist on the local box 
somewhere.

is this the kernel that is doing whatever check is failing? or is glibc 
wrapping the kernel syscall and doing some additional checking?

if it is the kernel that's throwing the error, is there some way of 
disabling this check? or do I have to go to raw sockets?

David Lang
