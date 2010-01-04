Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951Ab0ADUrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0ADUrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810Ab0ADUrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:47:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48344
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751Ab0ADUrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:47:09 -0500
Date: Mon, 04 Jan 2010 12:47:11 -0800 (PST)
Message-Id: <20100104.124711.50820580.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: guenter.roeck@ericsson.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Improve hash function used for full_name_hash()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100104122912.5f9d1ebb@nehalam>
References: <1262635784.8178.253.camel@groeck-laptop>
	<20100104122912.5f9d1ebb@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Mon, 4 Jan 2010 12:29:12 -0800

> On Mon, 04 Jan 2010 12:09:44 -0800
> Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> 
>> For example, when hashing "eth0" .. "eth9999" with a hash table size of 256,
>> the resulting minimum hash bucket depth is 0, the maximum depth is 563,
>> and the standard deviation is ~136.
> 
> The problem was a missing call to hash_32() on the result, and is
> already fixed in current kernel.

Added linux-kernel CC: to followup...
