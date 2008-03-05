Return-Path: <linux-kernel-owner+w=401wt.eu-S935733AbYCEBY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935733AbYCEBY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYCEBYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:24:44 -0500
Received: from relay2.sgi.com ([192.48.171.30]:56468 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755026AbYCEBYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:24:43 -0500
Date: Tue, 4 Mar 2008 19:24:36 -0600
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: xpl@amln.net, menage@google.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl, xemul@openvz.org, akpm@linux-foundation.org
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Message-Id: <20080304192436.5690bc0e.pj@sgi.com>
In-Reply-To: <47CBA787.8020100@cn.fujitsu.com>
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	<47C7EEAC.7010907@amln.net>
	<47CBA787.8020100@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote (quoted by Li Zefan):
>> A compromise might be to keep "tasks" unprefixed, and say that future
>> names get the "cgroup." prefix; 

Another stray idea, for the master of stray ideas ;), how about (1) renaming
all the cgroup files as you like, Paul M, even including tasks to cgroup.tasks
or whatever, and then (2) adding symlinks for the legacy names, such as:

    tasks -> cgroup.tasks

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
