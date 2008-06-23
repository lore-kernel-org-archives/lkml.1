Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYFWL3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYFWL3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYFWL3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:29:42 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:26092 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751972AbYFWL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:29:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=x3FpJ7Yw16itig0q0xNXUU5Yr02p8UZlC+wVpY3K89gwyLLTMBw+0LJRaomFFrm6j8rjL6VSAHP9WRCmNfwI85yvfyOMK+qGdVfvkOj62c7OQBRgUpS/83KgHWFkn5dzjKF82rOVwqqY5NBES5tWCySq4FbYDDsJ/oLDgLh5apA=  ;
X-YMail-OSG: GFRAlokVM1lE9ZJ2bhRThimC3zUVmCqCX8CY7khDN2ViWPaO6zIdt02kXE6nhb9uq14o5uRJN5lWXZ0F.KlKZ6_7b33lXq2PZ8hwV22xqmP748sXf8HoKL_iL4L1MaVnBwQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: benh@kernel.crashing.org
Subject: Re: [patch] x86 supports NO_IRQ convention
Date: Mon, 23 Jun 2008 04:28:20 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
References: <200806221953.18849.david-b@pacbell.net> <1214217751.8011.262.camel@pasglop>
In-Reply-To: <1214217751.8011.262.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230428.20388.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008, Benjamin Herrenschmidt wrote:
> NO_IRQ on x86 is 0

There is no such #define for it.
And since zero is used for timer IRQs, it's not invalid.
