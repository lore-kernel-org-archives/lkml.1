Return-Path: <linux-kernel-owner+w=401wt.eu-S965294AbXCAQFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965294AbXCAQFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965304AbXCAQFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:05:05 -0500
Received: from p02c11o145.mxlogic.net ([208.65.145.68]:38771 "EHLO
	p02c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294AbXCAQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:05:04 -0500
Subject: Re: wait_for_completion_timeout problem ???
From: Eli Cohen <eli@mellanox.co.il>
Reply-To: eli@mellanox.co.il
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0703010628u253a62cfi56cec22a1ee79d5f@mail.gmail.com>
References: <1172755932.5175.37.camel@mtls03>
	 <b647ffbd0703010628u253a62cfi56cec22a1ee79d5f@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Mellanox Technologies
Date: Thu, 01 Mar 2007 18:05:50 +0200
Message-Id: <1172765150.25580.10.camel@mtls03>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
X-Spam: [F=0.0315470423; S=0.031(2007010901)]
X-MAIL-FROM: <eli@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 15:28 +0100, Dmitry Adamushko wrote:

> So either all the users of wait_for_completion_timeout() should
> additionally check for x->done after they got scheduled
> 
> or
> 
> wait_for_completion_timeout() should return something different that
> encodes the fact /event happened/ and not just /event happened _and_ a
> caller has got scheduled back earlier than timeout.
> 

The second suggestion makes sense to me more and is more portable then
the first one.

