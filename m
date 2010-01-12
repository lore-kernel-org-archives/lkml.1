Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481Ab0ALAjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0ALAjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545Ab0ALAjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:39:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:48825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab0ALAjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:39:41 -0500
Message-ID: <4B4BC540.1090609@kernel.org>
Date: Tue, 12 Jan 2010 09:41:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 2/7] sysfs: Pack sysfs_dirent more tightly.
References: <m1d41g9z3q.fsf@fess.ebiederm.org> <1263241315-19499-2-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1263241315-19499-2-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Jan 2010 00:39:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 05:21 AM, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> Placing the 16bit s_mode between a pointer and a long doesn't pack well
> especailly on 64bit where we wast 48 bits.  So move s_mode and
> declare it as a unsigned short.  This is the sysfs backing store
> after all we don't need fields extra large just in case someday
> we want userspace to be able to use a larger value.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
