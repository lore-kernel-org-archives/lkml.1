Return-Path: <linux-kernel-owner+w=401wt.eu-S1765447AbXHWXns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765447AbXHWXns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761276AbXHWXng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:43:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:63441 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbXHWXnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:43:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=Jhvssdw+fOSiD3HDWrYKfCE1hfoeO+cWE7P6IpujaahLEQsAPHY+swcoVywjbZIdIjwYANbdlUgg2vZ8hDDUqS5SozZpCYZWcMfdT2Mgh1iwiVoCK7hAv2zDDmJKzpq1c/ncFfn8etxjpK9FmZVx9H/CFi0QcMbqoDTaSOedn2E=
Message-ID: <46CE1BA2.8070200@gmail.com>
Date: Fri, 24 Aug 2007 01:43:30 +0200
From: Luka Napotnik <luka.napotnik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: division and cpu usage
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm new to kernel development and have some questions.

1. Why can't I divide with regular casting to double ((double)a /
(double)b)? It gives me strange errors when compiling:

WARNING: "__divdf3" [/root....] undefined!
WARNING: "__addf3" [/root/...] undefined!
WARNING: "__floatsidf" [/root/...] undefined!

And if I compile with normal integers, I get zero as the result.

2. I'm trying to get the percentage of CPU used for a certain
task_struct and figured the following formula:

(task->utime + task->stime) / jiffies

Before calculating I convert all the variables to jiffies. Is this correct?

Please help.

Greets,
Lukla
