Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYL1Aas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYL1Aas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 19:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYL1Aaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 19:30:39 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:33586 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754582AbYL1Aaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 19:30:39 -0500
Message-ID: <4956C85A.7050501@pardus.org.tr>
Date: Sun, 28 Dec 2008 02:29:14 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: hid-dummy in 2.6.28_rc8
References: <495293BC.9000104@pardus.org.tr> <4956AF21.9070807@gmail.com>
In-Reply-To: <4956AF21.9070807@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
>
> Hi, the error is non-fatal in this case, in addition, it's intentional. The
> module is there only for dependency loading and kills itself by returning the
> error from load function to not eat resources any further after it does its job.
> The module will be removed completely in next few releases.
>
>   
Hi,

In fact, this was probably caused by CONFIG_HID_COMPAT=y which was 
loading all the hid_* modules(20~ or so) into the kernel. I disabled it 
and now the message has gone.

Thanks,

-- 

Ozan Çağlayan
<ozan_at_pardus.org.tr>

