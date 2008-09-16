Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYIPM1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYIPM1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYIPM1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:27:11 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:35878 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYIPM1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:27:10 -0400
Date: Tue, 16 Sep 2008 14:27:03 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v5][PATCH 2/8] General infrastructure for checkpoint
	restart
Message-ID: <20080916122703.GA24431@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Oren Laadan <orenl@cs.columbia.edu>,
	containers@lists.linux-foundation.org, jeremy@goop.org,
	linux-kernel@vger.kernel.org, arnd@arndb.de
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu> <1221347167-9956-3-git-send-email-orenl@cs.columbia.edu> <1221501750.16561.15.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1221501750.16561.15.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 11:02:30AM -0700, Dave Hansen wrote:
> All of the casting here is unnecessary.  'void *' behaves like 'char *'
> when you do arithmetic on it.  

No. Arithmetic on void pointer is not allowed by the standard. This is a
gcc extension. It's okay to be used in the Linux kernel but not in
general.

The second cast (from char * to void *) however is useless.

Bastian

-- 
Prepare for tomorrow -- get ready.
		-- Edith Keeler, "The City On the Edge of Forever",
		   stardate unknown
