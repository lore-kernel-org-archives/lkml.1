Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbZKIAfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbZKIAfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 19:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZKIAft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 19:35:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40533 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZKIAft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 19:35:49 -0500
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
References: <m13a4pjjh9.fsf@fess.ebiederm.org>
	<200911082215.HGJ57827.SJOVFFOHMOLFQt@I-love.SAKURA.ne.jp>
	<m1bpjch9hy.fsf@fess.ebiederm.org>
	<200911090012.nA90CF2i016994@www262.sakura.ne.jp>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 08 Nov 2009 16:35:51 -0800
In-Reply-To: <200911090012.nA90CF2i016994@www262.sakura.ne.jp> (Tetsuo Handa's message of "Mon\, 09 Nov 2009 09\:12\:15 +0900")
Message-ID: <m1iqdkedqw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Eric W. Biederman wrote:
>> There has been a gradual transition from the assumption that the table ends with
>> !ctl_name to the assumption that procname == NULL.  There is no sysctl entry
>> with a valid ctl_name without a valid procname.
>
> I see. Then, please add below one to your patchset.

Applied thanks.

Now that sysctl is all based on /proc/sys I hope someday we can kill
sysctl_perm.  As it seems redundant.

Eric
