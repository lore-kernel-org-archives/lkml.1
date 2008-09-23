Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYIWVBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYIWVBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYIWVBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:01:32 -0400
Received: from vena.lwn.net ([206.168.112.25]:46670 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYIWVBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:01:31 -0400
Date: Tue, 23 Sep 2008 15:01:29 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, serue@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
       debora@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4][resubmit] TPM: rcu locking
Message-ID: <20080923150129.0d8356e8@bike.lwn.net>
In-Reply-To: <1222201173.24276.15.camel@blackbox>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
	<1222190371-23814-3-git-send-email-srajiv@linux.vnet.ibm.com>
	<20080923181922.GE6637@linux.vnet.ibm.com>
	<1222201173.24276.15.camel@blackbox>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 17:19:33 -0300
Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:

> Protects tpm_chip_list when transversing it.

It all looks like it should work (though it might make sense to include
<linux/rcupdate.h> and <linux/rculist.h>.  But I have to ask: do you
really need the added complexity of RCU here?  I suspect that TPM
devices don't come and go very often...once most of us have ripped it
out, we tend to leave it out...:)

jon
