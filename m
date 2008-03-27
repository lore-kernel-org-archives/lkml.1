Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbYC0Qp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbYC0Qp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbYC0QpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:45:17 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:17253 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbYC0QpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:45:16 -0400
Subject: Re: [PATCH v2] likeliness accounting cleanup
From: Daniel Walker <dwalker@mvista.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: nickpiggin@yahoo.com.au, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47EAB608.6060204@tiscali.nl>
References: <47EAB608.6060204@tiscali.nl>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 09:45:13 -0700
Message-Id: <1206636313.4670.131.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 21:46 +0100, Roel Kluin wrote:
> Store __builtin_return_address (caller) rather than __func__ in likeliness
> struct. 'line' and 'type' are combined in 'label'
> 
> +/- now denotes whether expectation fails in less than 5% of the tests - rather
> than whether more unexpected than expected were encountered. The function at
> the displayed filename & line and the caller are not necessarily the same.
> A few more Likely Profiling Results changes were made.
> 
> struct seq_operations becomes static, unsigned ints true and false (shadowed)
> are replaced by pos and neg.

It's looks good to me .. You'll have to send it to Andrew to get it
included tho ..

Daniel

