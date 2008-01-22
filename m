Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYAVRKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYAVRKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYAVRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:10:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53777 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbYAVRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:10:38 -0500
Date: Tue, 22 Jan 2008 22:53:59 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] sched: don't take a mutex from interrupt context
Message-ID: <20080122172359.GA801@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080122023626.GA12213@darkstar.te-china.tietoenator.com> <1201019138.6341.24.camel@lappy> <20080122165121.GE31049@linux.vnet.ibm.com> <1201020454.6341.29.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201020454.6341.29.camel@lappy>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 05:47:34PM +0100, Peter Zijlstra wrote:
> It should not, that would be another bug, but from a quick glance at the
> code it doesn't do that.

Hmm I had it in my back of mind that printk() could sleep. Looks like
that has changed and so the patch you sent should be fine. 

Thanks!

- vatsa
