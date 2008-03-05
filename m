Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbYCEVMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbYCEVMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYCEVMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:12:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbYCEVL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:11:59 -0500
Message-ID: <47CF0BA8.8040204@zytor.com>
Date: Wed, 05 Mar 2008 13:07:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jan Hubicka <hubicka@ucw.cz>
CC: Joe Buck <Joe.Buck@synopsys.COM>, Michael Matz <matz@suse.de>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Hubicka wrote:
>> Yes, if there are four kernels that get it "wrong", that effectively means
>> that the ABI document doesn't describe reality and gcc has to adjust.
> 
> Kernels almost never follow ABI used by applications to last detail.
> Linux kernel is disabling red zone and use kernel code model, yet the
> ABI is not going to be adjusted for that.
> 
> This is resonably easy to fix on kernel side in signal handling, or by
> removing std usage completely (I believe it is not performance win, but
> some benchmarking would be needed to double check)

That's not the issue.  The issue is that the kernel leaks the DF from 
the code that took a signal to the signal handler.

	-hpa
