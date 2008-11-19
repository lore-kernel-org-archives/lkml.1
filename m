Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYKSPVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYKSPVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYKSPVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:21:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:24288 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYKSPVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:21:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,631,1220252400"; 
   d="scan'208";a="464919355"
Subject: Re: [RFC PATCH 03/11] net: infrastructure for hardware time
	stamping
From: Patrick Ohly <patrick.ohly@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <1227096528-24150-4-git-send-email-patrick.ohly@intel.com>
References: <1227096528-24150-1-git-send-email-patrick.ohly@intel.com>
	 <1227096528-24150-2-git-send-email-patrick.ohly@intel.com>
	 <1227096528-24150-3-git-send-email-patrick.ohly@intel.com>
	 <1227096528-24150-4-git-send-email-patrick.ohly@intel.com>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 16:21:03 +0100
Message-Id: <1227108063.16263.107.camel@ecld0pohly>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 12:08 +0000, Ohly, Patrick wrote:
> +       struct sock_exterr_skb *serr;
[...]
> +       memset(serr, 0, sizeof(serr));

Before someone else mentions it: this was meant to be "sizeof(*serr)" of
course.

-- 
Best Regards, Patrick Ohly

The content of this message is my personal opinion only and although
I am an employee of Intel, the statements I make here in no way
represent Intel's position on the issue, nor am I authorized to speak
on behalf of Intel on this matter.

