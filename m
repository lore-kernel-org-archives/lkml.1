Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0CJOPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:15:37 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:53491 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750769Ab0CJOPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:15:35 -0500
Date: Wed, 10 Mar 2010 09:15:30 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Regression, bisected] tcpdump broken in 2.6.34-rc1
Message-ID: <20100310141530.GA2267@emergent.ellipticsemi.com>
Mail-Followup-To: Xiaotian Feng <xtfeng@gmail.com>,
	linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
References: <20100310023143.GA20402@cpu18.student.cs>
 <7b6bb4a51003092236k4f5baa1tbb6dcf0b81038310@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b6bb4a51003092236k4f5baa1tbb6dcf0b81038310@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:36 Wed 10 Mar     , Xiaotian Feng wrote:
> On Wed, Mar 10, 2010 at 10:31 AM, Nick Bowler <nbowler@elliptictech.com> wrote:
> > After upgrading to 2.6.34-rc1, tcpdump fails with the following message:
> >
> >  tcpdump: setsockopt: Invalid argument
> 
> I think this regression has been fixed in today's net pull request.
> 
> http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=1162563f82b434e3099c9e6c1bbdba846d792f0d

Yes, cherry-picking that commit solves the issue.  Thanks.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
