Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbZLHGLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbZLHGLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 01:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932242AbZLHGLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 01:11:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60574 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbZLHGLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 01:11:39 -0500
Message-ID: <4B1DEE09.4010508@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 14:11:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com
Subject: Re: [RFC] [PATCH 5/5] cgroups: subsystem dependencies
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085854.GE18912@andrew.cmu.edu>
In-Reply-To: <20091204085854.GE18912@andrew.cmu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds a mechanism with which a subsystem can specify dependencies on
> other subsystems. Since subsystems can come and go, it would not be useful to
> refer to a depended-upon subsystem by subsys_id, so instead a NULL-terminated
> array of strings must be specified. Validation is done by scanning for each
> potential subsystem its list of subsystem names with strcmp at the end of
> parse_cgroupfs_options.

I once posted a patch to implement this feature, but it was
rejected by Andrew, because there was no user using it.

And still there is no user, right?


