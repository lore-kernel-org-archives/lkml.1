Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYLDVls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYLDVls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbYLDVli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:41:38 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:65238 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbYLDVlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:41:37 -0500
To: serue@us.ibm.com
Cc: sds@tycho.nsa.gov, jmorris@namei.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       takedakn@nttdata.co.jp, haradats@nttdata.co.jp,
       penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH (mmotm-2008-12-02-17-08)] Introducesecurity_path_set/clear() hooks.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <49364808.1070907@nttdata.co.jp>
	<493649C5.2060402@nttdata.co.jp>
	<1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil>
	<200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp>
	<20081204182005.GA14852@us.ibm.com>
In-Reply-To: <20081204182005.GA14852@us.ibm.com>
Message-Id: <200812050641.IHC43259.QSOMFLFOHFJtOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 5 Dec 2008 06:41:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> > Right. Locations of inserting security_path_set()/security_path_clear() pairs
> > are subset of mnt_want_write()/mnt_drop_write() pairs. Thus, we can insert
> > security_path_set()/security_path_clear() pairs into
> > mnt_want_write()/mnt_drop_write() pairs, if we can tolerate performance
> > regression. According to our rough measurement, there is about 8 - 22% of
> > performance regression.
> 
> ... compared to what, exactly?
> 
> If having CONFIG_SECURITY_PATH=y but TOMOYO  disabled has this kind of
> regression against just not having CONFIG_SECURITY_PATH, then no that is
> not acceptable.
> 
Comparison between a module using mnt_path.c and a module not using mnt_path.c .
If mp_update_mnt_path() is not called, there is no performance regression.
TOMOYO will need mp_update_mnt_path().

Regards.
