Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZGJWQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZGJWQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 18:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZGJWP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 18:15:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbZGJWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 18:15:56 -0400
Message-ID: <4A57BD9B.4030405@acm.org>
Date: Fri, 10 Jul 2009 18:15:55 -0400
From: Wayne Pollock <pollock@acm.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.22) Gecko/20090605 Lightning/0.9 Thunderbird/2.0.0.22 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: make xconfig fails on Fedora 10 for 2.6.30
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "make xconfig" command tried to link to "libXi.so".
I think this is actually a kernel bug; the binary this
make command builds should try to link to some "soname"
such as "libXi.so.6" instead, shouldn't it?

The work-around was to manually create the missing symlink
for "libXi.so".  I suspect other distro's install that
symlink automatically so maybe that's why the bug was
not discovered.  But I believe it is correct to say all
applications should use a soname (including the major
version number), and not just the "linker" name (the
name ending in ".so" with no version numbers).

Or am I missing something?

-- 
Wayne Pollock
