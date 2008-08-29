Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYH2RYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYH2RYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYH2RY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:24:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42489 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYH2RY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:24:26 -0400
Message-ID: <48B82FF4.3050000@zytor.com>
Date: Fri, 29 Aug 2008 10:20:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org> <Pine.LNX.4.64.0808290817190.21494@blonde.site> <48B80C26.2080002@goop.org>
In-Reply-To: <48B80C26.2080002@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> It would be easy to add another kernel parameter to select how much
> memory to reserve for corruption checking.  64k?  1M?
> 

Or just make the boot_corruption_check parameter take a range instead of 
a boolean.

	-hpa
