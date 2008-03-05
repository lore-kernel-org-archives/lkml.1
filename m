Return-Path: <linux-kernel-owner+w=401wt.eu-S1761728AbYCEVn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761728AbYCEVn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbYCEVnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:43:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48106 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805AbYCEVnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:43:08 -0500
Message-ID: <47CF11D6.7070901@zytor.com>
Date: Wed, 05 Mar 2008 13:34:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Richard Guenther <richard.guenther@gmail.com>
CC: Joe Buck <Joe.Buck@synopsys.com>, Michael Matz <matz@suse.de>,
       Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <20080305153020.GA24631@volta.aurel32.net>	 <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com>	 <20080305202319.GA17053@volta.aurel32.net>	 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>	 <20080305204234.GB17267@synopsys.com>	 <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>	 <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>	 <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
In-Reply-To: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guenther wrote:
> 
> We didn't yet run into this issue and build openSUSE with 4.3 since more than
> three month.
> 

Well, how often do you take a trap inside an overlapping memmove()?

	-hpa
