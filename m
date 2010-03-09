Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab0CIHjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:39:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:37765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab0CIHjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:39:00 -0500
Message-ID: <4B95FB06.6070906@kernel.org>
Date: Tue, 09 Mar 2010 16:38:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOpIEdvZGRhcmQgUm9zYQ==?= <andre.goddard@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs/file: move NULL checks to where they make sense
 and can occur
References: <2fcd155e7b67ba2d41de0a5a0751b3091bf849d8.1267785770.git.andre.goddard@gmail.com>
In-Reply-To: <2fcd155e7b67ba2d41de0a5a0751b3091bf849d8.1267785770.git.andre.goddard@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 07:38:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/05/2010 07:46 PM, André Goddard Rosa wrote:
> ... avoiding checking for NULL 2 times in a row when we already have a page.
> 
> It decreases code size:
> text    data     bss     dec     hex filename
> 4246      48    4136    8430    20ee fs/sysfs/file-BEFORE.o
> 4214      48    4136    8398    20ce fs/sysfs/file-AFTER.o
> 
> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

Nacked-by: Tejun Heo <tj@kernel.org>

For this level of micro optimization to be meaningful, the code path
should be *really* *really* hot, which none of sysfs code pats are.
Whatever is easier to the eyes wins.

Thanks.

-- 
tejun
