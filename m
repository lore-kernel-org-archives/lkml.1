Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYHGFsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYHGFsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 01:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYHGFsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 01:48:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:52649 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbYHGFsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 01:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=b6BWZbuym7LwKFZbRWb2MM7YkpsM2HfNRl/hw9scjsDET06jjgIKH1T3Jk/mf64uPp
         wvO0E6D6x+ZR0T4qu/jM2Tjiz8J4ohUaayks8DkqvKZxlYXdJMeAdCyJ8q056ebbg6QP
         Knw/ab4x7Z1ttUf1GTA4WEEw9IXFhKt29R/YM=
Message-ID: <b6a2187b0808062248m3f26caa5qbee477b489095985@mail.gmail.com>
Date: Thu, 7 Aug 2008 13:48:21 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Resurect proper handling of maxcpus= kernel option
Cc: Max.Krasnyansky@qualcomm.com, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Max Krasnyansky" <maxk@qualcomm.com>
In-Reply-To: <489A7359.8090607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com>
	 <489A7359.8090607@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 12:00 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:

> I booted my 2-core x86_32 box with maxcpus=1, and saw cpu1 was offline,

Test on Lenovo X60s (CoreDuo) 2 CPUs with maxcpus=1, and Dell R900
(Xeon QuadCore x4) 16 CPUs with maxcpus=8.

All working. I can switch online and offline up to 2CPUs on X60s, and
16CPUs on R900.

> and then I got softlockup BUG immediately when I onlined cpu1:

I'm using latest linux kernel.


Thanks,
Jeff.
