Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbZFLQt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbZFLQt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764005AbZFLQsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:48:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:38534 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763124AbZFLQsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:48:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,210,1243839600"; 
   d="scan'208";a="465833781"
Subject: Re: [Ilw] iwlagn crash on 2.6.29.4
From: reinette chatre <reinette.chatre@intel.com>
To: Robby Workman <rworkman@slackware.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0906112246330.23960@bob.slackware.com>
References: <alpine.LNX.1.10.0906112246330.23960@bob.slackware.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 09:55:49 -0700
Message-Id: <1244825750.20900.468.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-06-11 at 22:51 -0700, Robby Workman wrote:
> On 2.6.29.4, I just got a crash in iwlagn under heavy network
> throughput.  I was transferring a dvd iso from one box in my
> lan to another, and the following occurred:
> 
>    http://slackware.com/~rworkman/OOPS
> 
> It didn't bring the entire system to a halt (thankfully);
> removing and reloading the iwlagn module made everything
> just fine. :-)
> 
> If any more information is needed, let me know.  I'm more than
> willing to test patches and such...

Which hardware are you using?

We released new ucode for 4965, 5100, 5300, and 5350 that address this
issue. The new 4965 ucode should work fine with your driver. If you are
using later hardware then you need a more recent driver to be able to
use its new ucode.

You can download the new ucode from:
http://intellinuxwireless.org/?n=Downloads

Reinette

