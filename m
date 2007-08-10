Return-Path: <linux-kernel-owner+w=401wt.eu-S964912AbXHJRFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912AbXHJRFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763018AbXHJRFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:05:40 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54886 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756636AbXHJRFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:05:38 -0400
Message-ID: <386765535.06914@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 11 Aug 2007 01:05:34 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] writeback: 3-queue based writeback schedule
Message-ID: <20070810170534.GA5137@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	Ken Chen <kenchen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070810063412.238042387@mail.ustc.edu.cn> <20070810063419.549052142@mail.ustc.edu.cn> <20070810164715.GA5508@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810164715.GA5508@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 12:47:15AM +0800, Fengguang Wu wrote:
> In fact s_more_io is no longer necessary. We end up with a priority

Ah sorry, s_more_io is still needed to keep the time-ordering. I was
thinking of schedule fairness, in which sense only one cyclic list
will be sufficient.

