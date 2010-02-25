Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0BYPNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:13:24 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:52907 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759103Ab0BYPNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h6+sFRyJM/HUm1QrVKALRgYAm1fOmiEKlUsmGJ1stSsYWthzMVkOwLSzucdPI7vWuQ
         2bFSy1Pg4JgPZJNeE/IRgEjCPP3ng72Gmcs3/qW2krV5Gv4pbuQJd3v5Qmu3cQ/BjLgB
         6ujPXTx2+lypOyMJVn68ehgqIcWMVD/4oQv2Q=
Message-ID: <4B869438.502@gmail.com>
Date: Fri, 26 Feb 2010 00:16:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueues: microoptimize set_wq_data()
References: <20100224202035.GA26991@redhat.com> <4B85EA24.5020409@kernel.org> <4B8650A2.9060803@gmail.com> <20100225135547.GA6062@redhat.com>
In-Reply-To: <20100225135547.GA6062@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/25/2010 10:55 PM, Oleg Nesterov wrote:
>> Turns out I already have a patch which kills the second
>> work_data_bits() dereferencing in the series.  The first one is now in
>> the cmwq series which is about to be posted again.
> 
> OK, good.
> 
> Tejun, where can I find your cmwq patches? I'd like to take a look.

The third take was about a month ago.

  http://thread.gmane.org/gmane.linux.kernel/939353

The fourth take is just around the corner.

Thanks.

-- 
tejun
