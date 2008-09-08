Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYIHOEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYIHOEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYIHOEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:04:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41969 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbYIHOEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:04:23 -0400
To: Sheng Yang <sheng.yang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/2] x86: Add "virt flags"
From: Andi Kleen <andi@firstfloor.org>
References: <12208705553277-git-send-email-sheng.yang@intel.com>
Date: Mon, 08 Sep 2008 16:04:23 +0200
In-Reply-To: <12208705553277-git-send-email-sheng.yang@intel.com> (Sheng Yang's message of "Mon,  8 Sep 2008 18:42:33 +0800")
Message-ID: <87y722u42g.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sheng Yang <sheng.yang@intel.com> writes:
>
> But I still have concern, for this may broke some not that reliable userspace
> programs. So Avi suggested that we can add more fields to flags rather than a
> new catagory.


FWIW when I added the "power management:" flags back then for the
64bit kernel I didn't get any reports of user programs breaking. Also
some other fields got added like cpu cores or initial apicid etc. and
that also didn't lead to breakage. So adding new lines to cpuinfo
should be ok.

-Andi
-- 
ak@linux.intel.com
