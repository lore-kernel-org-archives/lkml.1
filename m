Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYFJVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYFJVlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYFJVlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:41:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbYFJVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:41:36 -0400
Message-ID: <484EF4E4.3070609@zytor.com>
Date: Tue, 10 Jun 2008 14:40:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: unconditionally enable PAT for AMD CPUs
References: <20080610140430.GE5024@alberich.amd.com>
In-Reply-To: <20080610140430.GE5024@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> If PAT support is advertised it should just work. No errata known.

This kills off the remainder of the whitelist (which is good), please 
actually this; this function doesn't do anything anymore and should be 
removed.

	-hpa
