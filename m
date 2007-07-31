Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbXGaHC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbXGaHC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXGaHCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:02:51 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:22008 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXGaHCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent:from:sender;
        b=AFke9Ub2YnO5Fi94gr0Dw24z1BgHJpQzZxRSRxgKcB1FDaeheWwTfZWrV48EsSJ1axxRzZzWyqXj3s6snvACcn2W0FidJoY6mNBIW10WUpAWT+u7WWEePOzWchHJAKzblaL9C2kf95eyPPAORcYU0lZ0bBrCFnJcIulzC/eHXvo=
Date: Tue, 31 Jul 2007 15:02:38 +0800
To: linux-kernel@vger.kernel.org
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Neil Horman <nhorman@tuxdriver.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 0/3] coredump: setuid core dump cleanups
Message-ID: <20070731070238.GA2412@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A year ago, commit abf75a5033d4da7b8a7e92321d74021d1fcfb502 was included
to fix a security vulnerability that is related to prctl privilege
escalation, and suid_dumpable (CVE-2006-2451). But the commit was just a
quick fix to prevent users from calling prctl(PR_SET_DUMPABLE, 2).

This patch series try to remove code that is related to the value 2
(suidsafe) core dump mode, and also re-implement Hidehiro-san's
re-implementation of dumpable using a bit flag instead of a pair (see
commit 6c5d523826dc639df709ed0f88c5d2ce25379652).

Thanks,
Eugene

