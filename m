Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYAXPN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYAXPN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYAXPNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:13:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:34023 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYAXPNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:13:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hXcMkmSBGKTytZTjyo3Jjv7Kp1LnOOQjqe1PgxFQ7Tp5tnZr1Y2LsS5C2c+sg/y0L
	Oz56iqkZqBJm0BVOQxpjQ==
Message-ID: <d43160c70801240713p1e7121c0k94ba210233a69dbb@mail.gmail.com>
Date: Thu, 24 Jan 2008 10:13:14 -0500
From: "Ross Biro" <rossb@google.com>
To: "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 1/2]: MM: Make Paget Tables Relocatable--Conditional TLB Flush
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080124140913.5FFE.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080123161340.A1AAEDCA00@localhost>
	 <20080124140913.5FFE.Y-GOTO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2008 12:20 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> This is a nitpick, but all of archtectures code except generic use
> MMF_NNED_FLUSH at clear_bit()...

I'd say that's a bit more than a nit.  Thanks for noticing that.
Please hang on, I think I've figured out how to reduce the 3.5% page
fault overhead to almost nothing.

    Ross
