Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYFAVcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYFAVcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYFAVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:32:13 -0400
Received: from sous-sol.org ([216.99.217.87]:53487 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYFAVcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:32:13 -0400
Date: Sun, 1 Jun 2008 14:31:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thorsten Knabe <linux@thorsten-knabe.de>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: Re: [BUG] Linux 2.6.25.4 task_struct leak
Message-ID: <20080601213134.GJ4018@sequoia.sous-sol.org>
References: <483EC624.90503@thorsten-knabe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483EC624.90503@thorsten-knabe.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc: Jeff)

* Thorsten Knabe (linux@thorsten-knabe.de) wrote:
> [5.] Most recent kernel version which did not have the bug:
> 2.6.23.17 does not leak task_structs.
> 2.6.24 - 2.6.25.3 has not been tested

Would you be able bisect this (or even just narrow it down a bit)?

> Running 2.6.23.16 i386 UML on a 2.6.25.4 i386 host does NOT leak
> task_structs.
> Running 64-bit UML guests has not been tested.
